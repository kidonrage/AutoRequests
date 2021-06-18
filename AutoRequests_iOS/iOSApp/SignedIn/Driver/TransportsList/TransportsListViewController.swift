//
//  TransportsListViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 23.05.2021.
//

import UIKit
import RxSwift
import AutoRequestsUIKit
import AutoRequestsKit

public final class TransportsListViewController: NiblessViewController {

    // MARK: - Visual Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DriverTransportRequestTableViewCell.self,
                           forCellReuseIdentifier: DriverTransportRequestTableViewCell.cellId)
        return tableView
    }()

    // MARK: - Private Properties
    // View Model
    private let viewModel: TransportsListViewModel
    private let bag = DisposeBag()
    // Child View Controllers
    private var requestDetailsViewController: RequestDetailsViewController?
    // Factories
    private var makeRequestDetailsViewController: (TransportRequest) -> RequestDetailsViewController

    // MARK: - Initializers
    public init(viewModel: TransportsListViewModel,
                requestDetailsViewControllerFactory: @escaping (TransportRequest) -> RequestDetailsViewController) {
        self.viewModel = viewModel
        self.makeRequestDetailsViewController = requestDetailsViewControllerFactory

        super.init()
    }

    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()

        title = "Мои заявки"

        viewModel.getUserRequests()
    }

    // MARK: - Private Methods
    private func present(_ view: DriverView) {
        switch view {
        case .transportsList:
            return
        case .requestDetails(let request):
            presentRequestDetails(of: request)
        }
    }

    private func presentRequestDetails(of request: TransportRequest) {
        let requestDetailsViewController = makeRequestDetailsViewController(request)
        self.requestDetailsViewController = requestDetailsViewController

        present(requestDetailsViewController, animated: true, completion: nil)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.myRequests.bind(
            to: tableView.rx.items(
                cellIdentifier:  DriverTransportRequestTableViewCell.cellId,
                cellType: DriverTransportRequestTableViewCell.self)) { [weak self] row, model, cell in
            cell.configure(with: model)
        }.disposed(by: bag)

        tableView.rx.itemSelected
            .bind(to: viewModel.selectedRequestIndexPath)
            .disposed(by: bag)

        viewModel.presentedView.subscribe(onNext: { [weak self] view in
            self?.present(view)
        }).disposed(by: bag)
    }

}
