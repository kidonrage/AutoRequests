//
//  CreateRequestViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 10.06.2021.
//

import UIKit
import RxSwift
import AutoRequestsKit
import AutoRequestsUIKit

public final class CreateRequestViewController: NiblessViewController, AlertDisplayer {

    // MARK: - Visual Components
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false

        tv.dataSource = self
        tv.delegate = self

        tv.register(DriverSettingTableViewCell.self, forCellReuseIdentifier: DriverSettingTableViewCell.cellId)
        tv.register(DateSettingTableViewCell.self, forCellReuseIdentifier: DateSettingTableViewCell.cellId)
        tv.register(TimeSettingTableViewCell.self, forCellReuseIdentifier: TimeSettingTableViewCell.cellId)
        tv.register(AddressSettingTableViewCell.self, forCellReuseIdentifier: AddressSettingTableViewCell.cellId)
        tv.register(CommentSettingTableViewCell.self, forCellReuseIdentifier: CommentSettingTableViewCell.cellId)

        tv.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        tv.contentInset = .init(top: 8, left: 0, bottom: 16, right: 0)

        tv.separatorStyle = .none

        return tv
    }()
    
    private let saveButtonDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .systemGray

        return view
    }()
    private let saveButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private let saveButton: NetworkActivityButton = {
        let button = NetworkActivityButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        button.layer.cornerRadius = 4
        button.setTitle("Сохранить", for: .normal)

        return button
    }()

    // MARK: - Private Properties
    private let viewModel: CreateRequestViewModel
    private let bag = DisposeBag()
    private let driverSelectorVC: DriverSelectorViewController

    // MARK: - Initializers
    init(viewModel: CreateRequestViewModel) {
        self.viewModel = viewModel
        self.driverSelectorVC = DriverSelectorViewController(viewModel: viewModel)

        super.init()
    }

    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Новая заявка"

        setupUI()
        bindViewModel()

        saveButton.addTarget(viewModel, action: #selector(CreateRequestViewModel.saveTransportRequest), for: .touchUpInside)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    // MARK: - Private Methods
    private func present(view: CreateRequestView) {
        switch view {
        case .createRequest:
            return
        case .requestCreated:
            navigationController?.popViewController(animated: true)
        }
    }

    private func setupUI() {
        view.backgroundColor = .white

        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKeyboardGesture)

        view.addSubview(tableView)
        view.addSubview(saveButtonContainer)

        saveButtonContainer.addSubview(saveButton)
        saveButtonContainer.addSubview(saveButtonDivider)

        NSLayoutConstraint.activate([
            saveButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            saveButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            saveButtonDivider.topAnchor.constraint(equalTo: saveButtonContainer.topAnchor),
            saveButtonDivider.trailingAnchor.constraint(equalTo: saveButtonContainer.trailingAnchor),
            saveButtonDivider.leadingAnchor.constraint(equalTo: saveButtonContainer.leadingAnchor),
            saveButtonDivider.heightAnchor.constraint(equalToConstant: 1),

            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.topAnchor.constraint(equalTo: saveButtonContainer.topAnchor, constant: 16),
            saveButton.heightAnchor.constraint(equalToConstant: 48),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButtonContainer.topAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.isRequestAvailableToSave
            .subscribe(onNext: { [weak self] isEnabled in
                self?.saveButton.isEnabled = isEnabled
                self?.saveButton.backgroundColor = isEnabled ? .systemGreen : .systemGray
            })
            .disposed(by: bag)

        viewModel.selectedDriver.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: bag)

        viewModel.isNetworkActivityInProgress.subscribe(onNext: { [weak self] inProgress in
//            self?.loginField.isEnabled = !inProgress
//            self?.passwordField.isEnabled = !inProgress
            self?.saveButton.setActivityIndicatorActive(inProgress)
        }).disposed(by: bag)

        viewModel.errorMessage.subscribe(onNext: { [weak self] message in
            guard let errorMessage = message else {
                return
            }

            self?.display(title: "Ошибка", message: errorMessage, actions: nil)
        }).disposed(by: bag)

        viewModel.view.subscribe(onNext: { [weak self] updatedView in
            self?.present(view: updatedView)
        }).disposed(by: bag)
    }

    private func getDateSettingCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let dateSettingCell = tableView.dequeueReusableCell(withIdentifier: DateSettingTableViewCell.cellId, for: indexPath) as? DateSettingTableViewCell else {
            return UITableViewCell()
        }

        dateSettingCell.configure(with: viewModel)

        return dateSettingCell
    }

    private func getTimeSettingCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let timeSettingCell = tableView.dequeueReusableCell(withIdentifier: TimeSettingTableViewCell.cellId, for: indexPath) as? TimeSettingTableViewCell else {
            return UITableViewCell()
        }

        timeSettingCell.configure(with: viewModel.timeSettingViewModel)

        return timeSettingCell
    }

    private func getDriverSettingCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let driverSettingCell = tableView.dequeueReusableCell(withIdentifier: DriverSettingTableViewCell.cellId, for: indexPath) as? DriverSettingTableViewCell else {
            return UITableViewCell()
        }

        driverSettingCell.configure(with: viewModel)

        return driverSettingCell
    }

    private func getCommentSettingCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let commentSettingCell = tableView.dequeueReusableCell(withIdentifier: CommentSettingTableViewCell.cellId, for: indexPath) as? CommentSettingTableViewCell else {
            return UITableViewCell()
        }

        commentSettingCell.configure(with: viewModel)

        return commentSettingCell
    }

    private func getAddressSettingCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let addressSettingCell = tableView.dequeueReusableCell(withIdentifier: AddressSettingTableViewCell.cellId, for: indexPath) as? AddressSettingTableViewCell else {
            return UITableViewCell()
        }

        addressSettingCell.configure(with: viewModel)

        return addressSettingCell
    }

    @objc private func dismissKeyboard() {
        tableView.endEditing(true)
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero

        setTableViewInsets(contentInset)
    }

    @objc private func handleKeyboardShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo as NSDictionary?,
            let keyboardSize = (userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?
            .cgRectValue.size
        else {
            return
        }

        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)

        setTableViewInsets(contentInset)
    }

    private func setTableViewInsets(_ insets: UIEdgeInsets) {
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }

}


// MARK: - UITableViewDataSource
extension CreateRequestViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = SettingSection(rawValue: indexPath.section)

        let cell: UITableViewCell

        switch setting {
        case .driver:
            cell = getDriverSettingCell(for: indexPath)
        case .date:
            cell = getDateSettingCell(for: indexPath)
        case .time:
            cell = getTimeSettingCell(for: indexPath)
        case .comment:
            cell = getCommentSettingCell(for: indexPath)
        case .address:
            cell = getAddressSettingCell(for: indexPath)
        default:
            cell = UITableViewCell()
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 8))
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}


// MARK: - UITableViewDelegate
extension CreateRequestViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = SettingSection(rawValue: indexPath.section)

        guard
            setting == SettingSection.driver,
            viewModel.driverOptions.value.count > 0
        else {
            return
        }

        present(driverSelectorVC, animated: true, completion: nil)
    }

}
