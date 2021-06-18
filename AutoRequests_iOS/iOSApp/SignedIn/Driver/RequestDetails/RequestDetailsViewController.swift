//
//  RequestDetailsViewController.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 18.06.2021.
//

import UIKit
import AutoRequestsUIKit
import AutoRequestsKit

public final class RequestDetailsViewController: NiblessViewController {

    // MARK: - Visual Components
    private let contentScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private let passengerNameView = TransportRequestValueView(valueName: "Пассажир", value: nil)
    private let passengerPhoneView = TransportRequestValueView(valueName: "Телефон", value: nil)
    private let addressView = TransportRequestValueView(valueName: "Адрес", value: nil)
    private let dateView = TransportRequestValueView(valueName: "Дата", value: nil)
    private let timeRangeView = TransportRequestValueView(valueName: "Время", value: nil)
    private let commentView = TransportRequestValueView(valueName: "Комментарий", value: nil)
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passengerNameView, passengerPhoneView, dateView, timeRangeView, commentView, UIView()])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    // MARK: - Private Properties
    private let viewModel: RequestDetailsViewModel

    // MARK: - Initializers
    public init(viewModel: RequestDetailsViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground

        commentView.valueLabel.numberOfLines = 0

        view.addSubview(contentScrollView)

        contentScrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            contentStack.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    private func bindViewModel() {
        let request = viewModel.request

        passengerNameView.value = request.passenger.displayName
        passengerPhoneView.value = request.passenger.mobileNumber
        addressView.value = request.address
        dateView.value = request.date
        timeRangeView.value = request.timeRange
        commentView.value = request.comment
    }


}
