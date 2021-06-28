//
//  AutoRequestsDriverDependencyContainer.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import AutoRequestsKit

final class AutoRequestsDriverDependencyContainer {

    // MARK: - Private Properties
    private let transportRequestsRepository: TransportRequestsRepository

    // MARK: - Initializers
    public init(transportRequestsRepository: TransportRequestsRepository) {
        self.transportRequestsRepository = transportRequestsRepository
    }

    // MARK: - Public Methods
    public func makeDriverNavigationViewController() -> DriverNavigationController {
        let transportsListVC = makeTransportListViewController()

        return DriverNavigationController(transportsListVC: transportsListVC)
    }

    // MARK: - Private Methods
    private func makeTransportListViewController() -> TransportsListViewController {
        let viewModel = makeTransportsListViewModel()

        return TransportsListViewController(viewModel: viewModel,
                                            requestDetailsViewControllerFactory: makeRequestDetailsViewController(request:))
    }

    private func makeTransportsListViewModel() -> TransportsListViewModel {
        return TransportsListViewModel(transportRequestsRepository: transportRequestsRepository)
    }

    private func makeRequestDetailsViewController(request: TransportApplication) -> RequestDetailsViewController {
        let viewModel = makeRequestDetailsViewModel(request: request)

        return RequestDetailsViewController(viewModel: viewModel)
    }

    private func makeRequestDetailsViewModel(request: TransportApplication) -> RequestDetailsViewModel {
        return RequestDetailsViewModel(request: request)
    }

}
