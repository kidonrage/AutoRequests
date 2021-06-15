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
    private let carView = TransportRequestValueView(valueName: "Автомобиль", value: nil)
    private let dateView = TransportRequestValueView(valueName: "Дата", value: nil)
    private let timeView = TransportRequestValueView(valueName: "Время", value: nil)
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [driverView, carView, dateView, timeView])
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
    public func configure(with transportRequest: TransportRequest) {
        driverView.value = "Driver Driverov"
        carView.value = "Toyota Camry 3.5"
        dateView.value = "07.05.1999"
        timeView.value = "10:00-11:00"
    }

    // MARK: - Private Methods
    private func setupUI() {
        contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }

    // MARK: - Constants
    public static let cellId = "PassengerTransportRequestTableViewCell"

}
