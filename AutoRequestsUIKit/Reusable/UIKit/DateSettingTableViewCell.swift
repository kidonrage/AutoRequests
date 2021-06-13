//
//  DateSettingTableViewCell.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 12.06.2021.
//

import UIKit
import AutoRequestsKit

public class DateSettingTableViewCell: SettingTableViewCell {

    // MARK: - Visual Components
    private let dateIconView = SettingIconView(imageSystemName: "calendar", backgroundColor: .systemRed)
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата поездки"
        return label
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ru-RU")
        return picker
    }()
    private lazy var dateViewText: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, datePicker])
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var dateView: UIStackView = {
        let dateIcon = UIStackView(arrangedSubviews: [UIView(), dateIconView, UIView()])
        dateIcon.axis = .vertical
        dateIcon.distribution = .equalCentering

        let stackView = UIStackView(arrangedSubviews: [dateIcon, dateViewText])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 8

        return stackView
    }()

    // MARK: - Private Properties

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(dateView)

        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            dateIconView.widthAnchor.constraint(equalToConstant: 48),
            dateIconView.heightAnchor.constraint(equalTo: dateIconView.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITableViewCell
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Constants
    public static let cellId = "DateSettingTableViewCell"

}
