//
//  DateSettingTableViewCell.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 12.06.2021.
//

import UIKit
import AutoRequestsKit
import RxCocoa
import RxSwift

public class DateSettingTableViewCell: SettingTableViewCell {

    // MARK: - Visual Components
    private let dateIconView = SettingIconView(imageSystemName: "calendar", backgroundColor: .systemRed)
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата поездки"
        return label
    }()
    private let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        return label
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false

        let locale = Locale(identifier: "ru-RU")

        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.locale = locale
        picker.minimumDate = Date()
        picker.calendar.locale = locale
        
        return picker
    }()
    private lazy var dateViewText: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), dateLabel, selectedDateLabel, UIView()])
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        return stackView
    }()
    private lazy var dateView: UIStackView = {
        let dateIcon = UIStackView(arrangedSubviews: [UIView(), dateIconView, UIView()])
        dateIcon.axis = .vertical
        dateIcon.distribution = .equalCentering

        let headerView = UIStackView(arrangedSubviews: [dateIcon, dateViewText])
        headerView.translatesAutoresizingMaskIntoConstraints = false

        headerView.axis = .horizontal
        headerView.spacing = 8

        let stackView = UIStackView(arrangedSubviews: [headerView, datePicker])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    // MARK: - Private Properties
    private var viewModel: DateSettingViewModelProtocol!
    private let bag = DisposeBag()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(dateView)

        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            dateIconView.widthAnchor.constraint(equalToConstant: 40),
            dateIconView.heightAnchor.constraint(equalTo: dateIconView.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITableViewCell
    public override func setSelected(_ selected: Bool, animated: Bool) {
        return
    }

    // MARK: - Public Methods
    public func configure(with viewModel: DateSettingViewModelProtocol) {
        self.viewModel = viewModel

        bindViewModel()
    }

    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.selectedDate.bind(to: datePicker.rx.date).disposed(by: bag)
        datePicker.rx.date.skip(1).bind(to: viewModel.selectedDate).disposed(by: bag)

        viewModel.selectedDate.map { (date) -> String in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru-RU")
            formatter.dateFormat = "E, d MMM y"
            return formatter.string(from: date)
        }.bind(to: selectedDateLabel.rx.text).disposed(by: bag)
    }

    // MARK: - Constants
    public static let cellId = "DateSettingTableViewCell"

}
