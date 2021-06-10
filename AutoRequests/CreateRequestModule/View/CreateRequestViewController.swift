//
//  CreateRequestViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 10.06.2021.
//

import UIKit

final class CreateRequestViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false

        return sv
    }()

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
        picker.locale = Locale(identifier: "ru-RU")
        return picker
    }()
    private lazy var dateViewText: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, datePicker])
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var dateView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateIconView, dateViewText])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

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
        picker.locale = Locale(identifier: "ru-RU")
        return picker
    }()
    private lazy var startTimeViewText: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [startTimeLabel, startTimePicker])
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
        picker.locale = Locale(identifier: "ru-RU")
        return picker
    }()
    private lazy var endTimeViewText: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [endTimeLabel, endTimePicker])
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var endTimeView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [endTimeIconView, endTimeViewText])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), dateView, startTimeView, endTimeView, UIView()])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.spacing = 16

        return stackView
    }()

    private let saveButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        button.layer.cornerRadius = 4
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = .systemGreen

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Новая заявка"

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        view.addSubview(saveButtonContainer)

        scrollView.addSubview(contentStack)

        saveButtonContainer.addSubview(saveButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButtonContainer.topAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            saveButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            saveButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveButtonContainer.heightAnchor.constraint(equalToConstant: 80),

            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.topAnchor.constraint(equalTo: saveButtonContainer.topAnchor, constant: 16),

            dateIconView.widthAnchor.constraint(equalToConstant: 48),
            dateIconView.heightAnchor.constraint(equalTo: dateIconView.widthAnchor),

            startTimeIconView.heightAnchor.constraint(equalToConstant: 48),
            startTimeIconView.widthAnchor.constraint(equalTo: startTimeIconView.heightAnchor),

            endTimeIconView.widthAnchor.constraint(equalToConstant: 48),
            endTimeIconView.heightAnchor.constraint(equalTo: endTimeIconView.widthAnchor),
        ])
    }

}
