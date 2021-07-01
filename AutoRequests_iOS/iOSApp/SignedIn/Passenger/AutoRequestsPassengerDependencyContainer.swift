//
//  AutoRequestsPassengerDependencyContainer.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import AutoRequestsKit

public final class AutoRequestsPassengerDependencyContainer {

    private let sharedMainViewModel: MainViewModel
    private let userSession: UserSession
    private let transportRequestsRepository: TransportRequestsRepository
    private let driversRepository: DriversRepository

    // MARK: - Initializers
    public init(userSession: UserSession,
                transportRequestsRepository: TransportRequestsRepository,
                driversRepository: DriversRepository,
                sharedMainViewModel: MainViewModel) {
        self.userSession = userSession
        self.transportRequestsRepository = transportRequestsRepository
        self.driversRepository = driversRepository
        self.sharedMainViewModel = sharedMainViewModel
    }

    // MARK: - Public Methods
    public func makePassengerNavigationViewController() -> PassengerNavigationController {
        let passengerTransportRequestsVC = makePassengerTransportRequestsViewController()

        return PassengerNavigationController(passengerTransportRequestsVC: passengerTransportRequestsVC)
    }

    // MARK: - Private Methods
    private func makePassengerTransportRequestsViewController() -> PassengerTransportRequestsViewController {
        let viewModel = makeUserTransportRequestsViewModel()
        let createRequestViewControllerFactory = {
            return self.makeCreateRequestViewController()
        }

        return PassengerTransportRequestsViewController(viewModel: viewModel,
                                                        createRequestViewControllerFactory: createRequestViewControllerFactory)
    }

    private func makeUserTransportRequestsViewModel() -> UserTransportRequestsViewModel {
        return UserTransportRequestsViewModel(transportRequestsRepository: transportRequestsRepository,
                                              notSignedInResponder: sharedMainViewModel)
    }

    private func makeCreateRequestViewController() -> CreateRequestViewController {
        let viewModel = makeCreateRequestViewModel()

        return CreateRequestViewController(viewModel: viewModel)
    }

    private func makeCreateRequestViewModel() -> CreateRequestViewModel {
        return CreateRequestViewModel(userSession: userSession,
                                      driversRepository: driversRepository,
                                      autoRequestsRepository: transportRequestsRepository)
    }

}
