//
//  TransportsListViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 23.05.2021.
//

import UIKit
import RxSwift
import RxDataSources
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
    private let activityIndicatory: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Private Properties
    // View Model
    private let viewModel: TransportsListViewModel
    private let bag = DisposeBag()
    // Child View Controllers
    private var requestDetailsViewController: RequestDetailsViewController?
    // Factories
    private var makeRequestDetailsViewController: (TransportApplication) -> RequestDetailsViewController

    // MARK: - Initializers
    public init(viewModel: TransportsListViewModel,
                requestDetailsViewControllerFactory: @escaping (TransportApplication) -> RequestDetailsViewController) {
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
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "arrow.left.to.line"), style: .plain, target: viewModel, action: #selector(UserTransportRequestsViewModel.logout)),
            UIBarButtonItem(customView: activityIndicatory)
        ]

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

    private func presentRequestDetails(of request: TransportApplication) {
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
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TransportApplication>> { (dataSource, table, indexPath, item) -> UITableViewCell in
            let cell = table.dequeueReusableCell(withIdentifier: DriverTransportRequestTableViewCell.cellId) as! DriverTransportRequestTableViewCell

            cell.configure(with: item)

            return cell
        }

        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }

        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        tableView.rx.itemSelected
            .bind(to: viewModel.selectedRequestIndexPath)
            .disposed(by: bag)

        viewModel.isNetworkActivityInProgress
            .bind(to: activityIndicatory.rx.isAnimating)
            .disposed(by: bag)

        viewModel.presentedView.subscribe(onNext: { [weak self] view in
            self?.present(view)
        }).disposed(by: bag)
    }

}
