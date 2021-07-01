//
//  PassengerTransportRequestsViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 23.05.2021.
//

import UIKit
import RxSwift
import RxDataSources
import AutoRequestsUIKit
import AutoRequestsKit

public final class PassengerTransportRequestsViewController: NiblessViewController {

    // MARK: - Visual Components
    private let myRequestsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PassengerTransportRequestTableViewCell.self, forCellReuseIdentifier: PassengerTransportRequestTableViewCell.cellId)
        return tableView
    }()
    
    private let activityIndicatory: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Private Properties
    // ViewModel
    private let viewModel: UserTransportRequestsViewModel
    private let bag = DisposeBag()
    // Child View Controllers
    private var createRequestVC: CreateRequestViewController?
    // Factories
    private let makeCreateRequestVC: () -> CreateRequestViewController

    // MARK: - Initializers
    public init(viewModel: UserTransportRequestsViewModel,
                createRequestViewControllerFactory: @escaping () -> CreateRequestViewController) {
        self.viewModel = viewModel
        self.makeCreateRequestVC = createRequestViewControllerFactory

        super.init()
    }

    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "arrow.left.to.line"), style: .plain, target: viewModel, action: #selector(UserTransportRequestsViewModel.logout)),
            UIBarButtonItem(customView: activityIndicatory)
        ]
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.getUserRequests()
    }

    // MARK: - Private Methods
    private func setupUI() {
        title = "Мои заявки"

        view.backgroundColor = .systemBackground

        view.addSubview(myRequestsTableView)

        NSLayoutConstraint.activate([
            myRequestsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myRequestsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myRequestsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myRequestsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func bindViewModel() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TransportApplication>> { (dataSource, table, indexPath, item) -> UITableViewCell in
            let cell = table.dequeueReusableCell(withIdentifier: PassengerTransportRequestTableViewCell.cellId) as! PassengerTransportRequestTableViewCell

            cell.configure(with: item)

            return cell
        }

        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }

        viewModel.sections
            .bind(to: myRequestsTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
//        viewModel.myRequests.bind(
//            to: myRequestsTableView.rx.items(
//                cellIdentifier:  PassengerTransportRequestTableViewCell.cellId,
//                cellType: PassengerTransportRequestTableViewCell.self)) { [weak self] row, model, cell in
//            cell.configure(with: model)
//        }.disposed(by: bag)

        viewModel.isNetworkActivityInProgress
            .bind(to: activityIndicatory.rx.isAnimating)
            .disposed(by: bag)

        //        optionsTable.rx.itemSelected.subscribe(onNext: { [weak self] (selectedIndexPath) in
        //            self?.viewModel.handleSelectDriver(on: selectedIndexPath)
        //            self?.optionsTable.reloadData()
        //        }).disposed(by: bag)
    }

    @objc private func add() {
        let createRequestVC: CreateRequestViewController

        if let selfCreateRequestVC = self.createRequestVC {
            createRequestVC = selfCreateRequestVC
        } else {
            createRequestVC = makeCreateRequestVC()
            self.createRequestVC = createRequestVC
        }

        navigationController?.pushViewController(createRequestVC, animated: true)
    }

}

extension PassengerTransportRequestsViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
