//
//  PassengerTransportRequestTableViewCell.swift
//  AutoRequestsUIKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import UIKit
import AutoRequestsKit

public final class PassengerTransportRequestTableViewCell: UITableViewCell {

    // MARK: - Visual Components
    private let driverView = TransportRequestValueView(valueName: "Водитель", value: nil)
    private let phoneView = TransportRequestValueView(valueName: "Телефон", value: nil)
    private let carView = TransportRequestValueView(valueName: "Автомобиль", value: nil)
    private let dateView = TransportRequestValueView(valueName: "Дата", value: nil)
    private let timeView = TransportRequestValueView(valueName: "Время", value: nil)
    private lazy var contentStack: UIStackView = {
        let dateTimeView = UIStackView(arrangedSubviews: [dateView, timeView])
        dateTimeView.spacing = 8
        dateTimeView.distribution = .fillEqually

        let stackView = UIStackView(arrangedSubviews: [driverView, phoneView, carView, dateTimeView])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    // MARK: - Initializers
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    public func configure(with transportRequest: TransportApplication) {
        driverView.value = transportRequest.driver.displayName
        phoneView.value = transportRequest.driver.mobileNumber
        carView.value = transportRequest.driver.car.name
        dateView.value = transportRequest.date
        timeView.value = transportRequest.timeRange
    }

    // MARK: - Private Methods
    private func setupUI() {
        contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }

    // MARK: - Constants
    public static let cellId = "PassengerTransportRequestTableViewCell"

}
