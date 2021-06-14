//
//  TimeSettingTableViewCell.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 12.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

import AutoRequestsKit

public final class TimeSettingTableViewCell: SettingTableViewCell {

    // MARK: - Visual Components
    private let timeIconView = SettingIconView(imageSystemName: "timer", backgroundColor: .systemYellow)
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время поездки"
        return label
    }()
    private let timePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = nil
        picker.dataSource = nil
        return picker
    }()
    private lazy var timeViewText: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, timePicker])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private lazy var timeView: UIStackView = {
        let timeIcon = UIStackView(arrangedSubviews: [UIView(), timeIconView, UIView()])
        timeIcon.axis = .vertical
        timeIcon.distribution = .equalCentering

        let headerView = UIStackView(arrangedSubviews: [timeIcon, timeLabel])
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.axis = .horizontal
        headerView.spacing = 8

        let stackView = UIStackView(arrangedSubviews: [headerView, timePicker])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()


    // MARK: - Private Properties
    private var viewModel: TimeSettingViewModel!
    private let bag = DisposeBag()


    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(timeView)

        NSLayoutConstraint.activate([
            timeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            timeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            timePicker.heightAnchor.constraint(equalToConstant: 120),

            timeIconView.widthAnchor.constraint(equalToConstant: 40),
            timeIconView.heightAnchor.constraint(equalTo: timeIconView.widthAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UITableViewCell
    public override func setSelected(_ selected: Bool, animated: Bool) {
        return
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        timePicker.delegate = nil
        timePicker.dataSource = nil
    }


    // MARK: - Public Methods
    public func configure(with viewModel: TimeSettingViewModel) {
        self.viewModel = viewModel

        bindViewModel()
    }


    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.timeOptions
            .bind(to: timePicker.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: bag)

        timePicker.rx.itemSelected.subscribe(onNext: { [weak self] (row: Int, component: Int) in
            self?.viewModel.selectedTimeIndex.onNext(row)
        }).disposed(by: bag)

        viewModel.selectedTimeIndex.subscribe(onNext: { [weak self] index in
            self?.timePicker.selectRow(index ?? 0, inComponent: 0, animated: false)
        }).disposed(by: bag)
    }


    // MARK: - Constants
    public static let cellId = "TimeSettingTableViewCell"

}
