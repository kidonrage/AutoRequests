//
//  TimeSettingTableViewCell.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 12.06.2021.
//

import UIKit
import RxSwift

import AutoRequestsKit

public final class TimeSettingTableViewCell: SettingTableViewCell {

    // MARK: - Visual Components
    private let startTimeIconView = SettingIconView(imageSystemName: "hourglass.bottomhalf.fill", backgroundColor: .systemYellow)
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Начало поездки"
        return label
    }()
    private let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false

        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ru-RU")
        picker.minuteInterval = 10

        return picker
    }()
    private lazy var startTimeViewText: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [startTimeLabel, startTimePicker])
        stackView.axis = .horizontal
        stackView.spacing = 8
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
        label.text = "Конец поездки"
        return label
    }()
    private let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ru-RU")
        picker.minuteInterval = 10

        return picker
    }()
    private lazy var endTimeViewText: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [endTimeLabel, endTimePicker])

        stackView.axis = .horizontal
        stackView.spacing = 8

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

    // MARK: - Private Properties
    private var viewModel: TimeSettingViewModel!
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

            endTimeIconView.widthAnchor.constraint(equalToConstant: 48),
            endTimeIconView.heightAnchor.constraint(equalTo: endTimeIconView.widthAnchor),

            startTimeIconView.widthAnchor.constraint(equalToConstant: 48),
            startTimeIconView.heightAnchor.constraint(equalTo: startTimeIconView.widthAnchor),
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
    public func configure(with viewModel: TimeSettingViewModel) {
        self.viewModel = viewModel

        bindViewModel()
    }

    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.selectedStartTime
            .bind(to: startTimePicker.rx.date)
            .disposed(by: bag)
        startTimePicker.rx.date
            .bind(to: viewModel.selectedStartTime)
            .disposed(by: bag)


        viewModel.selectedEndTime
            .bind(to: endTimePicker.rx.date)
            .disposed(by: bag)
        endTimePicker.rx.date
            .bind(to: viewModel.selectedEndTime)
            .disposed(by: bag)

        viewModel.selectedEndTime.subscribe(onNext: { date in print("next end date", date)}).disposed(by: bag)
        viewModel.selectedStartTime.subscribe(onNext: { date in print("next start date", date)}).disposed(by: bag)

        Observable.combineLatest(
            startTimePicker.rx.date,
            viewModel.selectedEndTime).subscribe(onNext: { [weak self] startTime, endTime in

                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru-RU")
                formatter.dateFormat = "E, d MMM y HH:MM:ss"
                print(formatter.string(from: startTime), formatter.string(from: endTime), endTime < startTime)
            if endTime < startTime {
                self?.viewModel.selectedEndTime.onNext(startTime)
            }
        }).disposed(by: bag)
    }

    // MARK: - Constants
    public static let cellId = "TimeSettingTableViewCell"

}
