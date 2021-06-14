//
//  AddressSettingTableViewCell.swift
//  AutoRequestsUIKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import UIKit
import RxSwift

import AutoRequestsKit

public final class AddressSettingTableViewCell: SettingTableViewCell {

    // MARK: - Visual Components
    private let addressIconView = SettingIconView(imageSystemName: "mappin", backgroundColor: .systemGray)
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Адрес"
        return label
    }()
    private let addressField: UITextField = {
        let field = UITextField()
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 4
        field.placeholder = "Оборонная, 1"
        return field
    }()
    private lazy var addressView: UIStackView = {
        let addressIcon = UIStackView(arrangedSubviews: [UIView(), addressIconView, UIView()])
        addressIcon.axis = .vertical
        addressIcon.distribution = .equalCentering

        let headerView = UIStackView(arrangedSubviews: [addressIcon, addressLabel])
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.axis = .horizontal
        headerView.spacing = 8

        let stackView = UIStackView(arrangedSubviews: [headerView, addressField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    // MARK: - Private Properties
    private var viewModel: AddressSettingViewModelProtocol! {
        didSet {
            bindViewModel()
        }
    }
    private let bag = DisposeBag()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(addressView)

        NSLayoutConstraint.activate([
            addressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            addressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            addressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            addressIconView.widthAnchor.constraint(equalToConstant: 40),
            addressIconView.heightAnchor.constraint(equalTo: addressIconView.widthAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITableView
    public override func setSelected(_ selected: Bool, animated: Bool) {
        return
    }

    // MARK: - Public Methods
    public func configure(with viewModel: AddressSettingViewModelProtocol) {
        self.viewModel = viewModel
    }

    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.selectedAddress.bind(to: addressField.rx.text).disposed(by: bag)
        addressField.rx.text.bind(to: viewModel.selectedAddress).disposed(by: bag)
    }

    // MARK: - Constants
    public static let cellId = "AddressSettingTableViewCell"

}
