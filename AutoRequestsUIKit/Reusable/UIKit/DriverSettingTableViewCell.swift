//
//  DriverSettingCell.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 12.06.2021.
//

import UIKit
import RxSwift

import AutoRequestsKit

public final class DriverSettingTableViewCell: SettingTableViewCell {

    // MARK: - Visual Components
    private let driverIconView = SettingIconView(imageSystemName: "person", backgroundColor: .systemGray)
    private let driverLabel: UILabel = {
        let label = UILabel()
        label.text = "Водитель"
        return label
    }()
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    private lazy var driverView: UIStackView = {
        let driverIcon = UIStackView(arrangedSubviews: [UIView(), driverIconView, UIView()])
        driverIcon.axis = .vertical
        driverIcon.distribution = .equalCentering

        let driverText = UIStackView(arrangedSubviews: [UIView(), driverLabel, hintLabel, UIView()])
        driverText.axis = .vertical
        driverText.distribution = .equalCentering

        let stackView = UIStackView(arrangedSubviews: [driverIcon, driverText])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    private let carIconView = SettingIconView(imageSystemName: "car", backgroundColor: .systemGray)
    private let carLabel: UILabel = {
        let label = UILabel()
        label.text = "Автомобиль"
        return label
    }()
    private lazy var carView: UIStackView = {
        let carIcon = UIStackView(arrangedSubviews: [UIView(), carIconView, UIView()])
        carIcon.axis = .vertical
        carIcon.distribution = .equalCentering

        let stackView = UIStackView(arrangedSubviews: [carIcon, carLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [driverView, divider, carView])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.spacing = 8
        stackView.axis = .vertical

        return stackView
    }()

    // MARK: - Private Properties
    private var viewModel: DriverSettingViewModel!
    private let bag = DisposeBag()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            driverIconView.widthAnchor.constraint(equalToConstant: 48),
            driverIconView.heightAnchor.constraint(equalTo: driverIconView.widthAnchor),

            carIconView.widthAnchor.constraint(equalToConstant: 48),
            carIconView.heightAnchor.constraint(equalTo: carIconView.widthAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITableViewCell
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Public Methods
    public func configure(with viewModel: DriverSettingViewModel) {
        self.viewModel = viewModel

        bindViewModel()
    }

    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.selectedCar
            .map { $0 == nil }
            .bind(to: carView.rx.isHidden, divider.rx.isHidden)
            .disposed(by: bag)

        Observable
            .combineLatest(viewModel.selectedDriver, viewModel.driverOptions)
            .subscribe(onNext: { [weak self] selectedDriver, driversOptions in
                if selectedDriver != nil {

                } else {
                    let isAnyOptions = driversOptions.count > 0

                    self?.hintLabel.text = isAnyOptions ? "Нажмите, чтобы выбрать" : "Не найдено ни одного водителя на такие дату и время"
                    self?.hintLabel.textColor = isAnyOptions ? .systemGreen : .systemRed
                }
            }).disposed(by: bag)
    }

    // MARK: - Constants
    public static let cellId = "DriverSettingTableViewCell"

}
