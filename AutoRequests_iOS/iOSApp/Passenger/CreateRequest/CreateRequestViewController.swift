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

final class CreateRequestViewController: UIViewController {

    // MARK: - Visual Components
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false

        tv.dataSource = self
        tv.delegate = self

        tv.register(DriverSettingTableViewCell.self, forCellReuseIdentifier: DriverSettingTableViewCell.cellId)
        tv.register(DateSettingTableViewCell.self, forCellReuseIdentifier: DateSettingTableViewCell.cellId)
        tv.register(TimeSettingTableViewCell.self, forCellReuseIdentifier: TimeSettingTableViewCell.cellId)

        tv.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        tv.contentInset = .init(top: 8, left: 0, bottom: 16, right: 0)

        tv.separatorStyle = .none

        return tv
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

        return button
    }()

    // MARK: - Private Properties
    private let viewModel: CreateRequestViewModel
    private let bag = DisposeBag()
    private let driverSelectorVC: DriverSelectorViewController

    // MARK: - Initializers
    init(viewModel: CreateRequestViewModel) {
        self.viewModel = viewModel
        self.driverSelectorVC = DriverSelectorViewController(viewModel: viewModel.driverSettingViewModel)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Новая заявка"

        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(tableView)
        view.addSubview(saveButtonContainer)

        saveButtonContainer.addSubview(saveButton)

        NSLayoutConstraint.activate([
            saveButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            saveButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveButtonContainer.heightAnchor.constraint(equalToConstant: 80),

            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.topAnchor.constraint(equalTo: saveButtonContainer.topAnchor, constant: 16),

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
    }

    private func getDateSettingCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let dateSettingCell = tableView.dequeueReusableCell(withIdentifier: DateSettingTableViewCell.cellId, for: indexPath) as? DateSettingTableViewCell else {
            return UITableViewCell()
        }

        dateSettingCell.configure(with: viewModel.dateSettingViewModel)

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

        driverSettingCell.configure(with: viewModel.driverSettingViewModel)

        return driverSettingCell
    }

}


// MARK: - UITableViewDataSource
extension CreateRequestViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = SettingSection(rawValue: indexPath.section)

        let cell: UITableViewCell

        switch setting {
        case .driver:
            cell = getDriverSettingCell(for: indexPath)
        case .date:
            cell = getDateSettingCell(for: indexPath)
        case .time:
            cell = getTimeSettingCell(for: indexPath)
        default:
            cell = UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 8))
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}


// MARK: - UITableViewDelegate
extension CreateRequestViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = SettingSection(rawValue: indexPath.section)

        guard
            setting == SettingSection.driver,
            let shouldOpenOptions = try? viewModel.driverSettingViewModel.driverOptions.value().count > 0,
            shouldOpenOptions
        else {
            return
        }

        present(driverSelectorVC, animated: true, completion: nil)
    }

}
