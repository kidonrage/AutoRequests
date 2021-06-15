//
//  DriverSelectorViewController.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import UIKit
import RxSwift

import AutoRequestsKit

public final class DriverSelectorViewController: UIViewController {

    // MARK: - VisualComponents
    private lazy var optionsTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(DriverOptionTableViewCell.self, forCellReuseIdentifier: DriverOptionTableViewCell.cellId)

//        tableView.dataSource = self
//        tableView.delegate = self

        return tableView
    }()

    // MARK: - Private Properties
    private let viewModel: DriverSettingViewModel
    private let bag = DisposeBag()

    // MARK: - Initializers
    public init(viewModel: DriverSettingViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(optionsTable)

        NSLayoutConstraint.activate([
            optionsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            optionsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            optionsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            optionsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.driverOptions.bind(
            to: optionsTable.rx.items(
                cellIdentifier:  DriverOptionTableViewCell.cellId,
                cellType: UITableViewCell.self)) { [weak self] row, model, cell in
            cell.textLabel?.text = model.displayName
            cell.detailTextLabel?.text = "Toyota Corolla 2017"

            if let selectedDriver = try? self?.viewModel.selectedDriver.value() {
                cell.accessoryType = model._id == selectedDriver._id ? .checkmark : .none
            }
        }.disposed(by: bag)

        optionsTable.rx.itemSelected.subscribe(onNext: { [weak self] (selectedIndexPath) in
            self?.viewModel.handleSelectDriver(on: selectedIndexPath)
            self?.optionsTable.reloadData()
        }).disposed(by: bag)
    }

}


// MARK: - UITableViewDataSource
//extension DriverSelectorViewController: UITableViewDataSource {
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return vi
//    }
//
//}


// MARK: - UITableViewDelegate
//extension DriverSelectorViewController: UITableViewDelegate {
//
//
//}
