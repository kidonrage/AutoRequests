//
//  TimeTableViewCell.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 12.06.2021.
//

import UIKit

public final class TimeSettingTableViewCell: SettingTableViewCell {

    // MARK: - Visual Components
    private let startTimeIconView = SettingIconView(imageSystemName: "hourglass.bottomhalf.fill", backgroundColor: .systemYellow)
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время начала поездки"
        return label
    }()
    private let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ru-RU")
        return picker
    }()
    private lazy var startTimeViewText: UIStackView = {
        let pickerView = UIStackView(arrangedSubviews: [startTimePicker, UIView()])

        let stackView = UIStackView(arrangedSubviews: [startTimeLabel, pickerView])
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var startTimeView: UIStackView = {
        let startTimeIcon = UIStackView(arrangedSubviews: [UIView(), startTimeIconView, UIView()])
        startTimeIcon.axis = .vertical
        startTimeIcon.distribution = .equalCentering

        let stackView = UIStackView(arrangedSubviews: [startTimeIcon, startTimeViewText])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    private let endTimeIconView = SettingIconView(imageSystemName: "hourglass.tophalf.fill", backgroundColor: .systemGreen)
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время конца поездки"
        return label
    }()
    private let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ru-RU")
        return picker
    }()
    private lazy var endTimeViewText: UIStackView = {
        let pickerView = UIStackView(arrangedSubviews: [endTimePicker, UIView()])

        let stackView = UIStackView(arrangedSubviews: [endTimeLabel, pickerView])
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var endTimeView: UIStackView = {
        let endTimeIcon = UIStackView(arrangedSubviews: [UIView(), endTimeIconView, UIView()])
        endTimeIcon.axis = .vertical
        endTimeIcon.distribution = .equalCentering

        let stackView = UIStackView(arrangedSubviews: [endTimeIcon, endTimeViewText])
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
        let stackView = UIStackView(arrangedSubviews: [startTimeView, divider, endTimeView])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.spacing = 8
        stackView.axis = .vertical

        return stackView
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            endTimeIconView.widthAnchor.constraint(equalToConstant: 48),
            endTimeIconView.heightAnchor.constraint(equalTo: endTimeIconView.widthAnchor),

            startTimeIconView.widthAnchor.constraint(equalToConstant: 48),
            startTimeIconView.heightAnchor.constraint(equalTo: startTimeIconView.widthAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public static let cellId = "TimeSettingTableViewCell"

}
