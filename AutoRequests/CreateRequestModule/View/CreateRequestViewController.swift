//
//  CreateRequestViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 10.06.2021.
//

import UIKit

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

        tv.backgroundColor = .lightGray
        tv.contentInset = .init(top: 8, left: 0, bottom: 16, right: 0)

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
        button.backgroundColor = .systemGreen

        return button
    }()

    // MARK: - Private Properties
    private let viewModel: CreateRequestViewModelProtocol

    // MARK: - Initializers
    init(viewModel: CreateRequestViewModelProtocol) {
        self.viewModel = viewModel

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
            cell = tableView.dequeueReusableCell(withIdentifier: DriverSettingTableViewCell.cellId, for: indexPath)
        case .date:
            cell = tableView.dequeueReusableCell(withIdentifier: DateSettingTableViewCell.cellId, for: indexPath)
        case .time:
            cell = tableView.dequeueReusableCell(withIdentifier: TimeSettingTableViewCell.cellId, for: indexPath)
        default:
            cell = UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 8))
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}


// MARK: - UITableViewDelegate
extension CreateRequestViewController: UITableViewDelegate {



}
