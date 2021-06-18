//
//  DriverTransportRequestTableViewCell.swift
//  AutoRequestsUIKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import UIKit
import AutoRequestsKit

public final class DriverTransportRequestTableViewCell: UITableViewCell {

    // MARK: - Visual Components
    private let passengerView = TransportRequestValueView(valueName: "Пассажир", value: nil)
    private let dateView = TransportRequestValueView(valueName: "Дата", value: nil)
    private let timeView = TransportRequestValueView(valueName: "Время", value: nil)
    private lazy var contentStack: UIStackView = {
        let dateTimeView = UIStackView(arrangedSubviews: [dateView, timeView])
        dateTimeView.spacing = 8

        let stackView = UIStackView(arrangedSubviews: [passengerView, dateTimeView])
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
        passengerView.value = "Passenger Passangerov"
        dateView.value = "07.05.1999"
        timeView.value = "10:00-11:00"
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
    public static let cellId = "DriverTransportRequestTableViewCell"

}
