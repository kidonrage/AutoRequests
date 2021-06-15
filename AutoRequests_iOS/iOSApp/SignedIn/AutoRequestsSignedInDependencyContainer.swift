//
//  AutoRequestsSignedInDependencyContainer.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import AutoRequestsKit

public final class AutoRequestsSignedInDependencyContainer {

    // MARK: - Private Properties
    // From parent container
    private let userSessionRepository: UserSessionRepository
    private let mainViewModel: MainViewModel
    // Context
    private let userSession: UserSession
    // Long-lived dependencies
    private let signedInViewModel: SignedInViewModel
    private let sharedTransportRequestsRepository: TransportRequestsRepository

    // MARK: - Initializers
    public init(userSession: UserSession, appDependencyContainer: AutoRequestsAppDependencyContainer) {
        func makeTransportRequestsRepository() -> TransportRequestsRepository {
            let remoteAPI = makeTransportRequestsRemoteAPI()

            return AutoRequestsTransportRequestsRepository(remoteAPI: remoteAPI)
        }

        func makeTransportRequestsRemoteAPI() -> TransportRequestsRemoteAPI {
            return FakeTransportRequestsRemoteAPI(userSession: userSession)
        }

        func makeSignedInViewModel() -> SignedInViewModel {
            return SignedInViewModel(userSession: userSession)
        }

        self.sharedTransportRequestsRepository = makeTransportRequestsRepository()
        self.signedInViewModel = makeSignedInViewModel()

        self.userSession = userSession

        self.userSessionRepository = appDependencyContainer.sharedUserSessionRepository
        self.mainViewModel = appDependencyContainer.sharedMainViewModel
    }

    // MARK: - Public Methods
    public func makeSignedInViewController() -> SignedInViewController {
        return SignedInViewController(viewModel: signedInViewModel,
                                      driverNavigationVCFactory: makeDriverNavigationViewController,
                                      passengerNavigationVCFactory: makePassengerNavigationViewController)
    }

    // MARK: - Private Methods

    // Driver
    private func makeDriverNavigationViewController() -> DriverNavigationController {
        let transportsListVC = makeTransportListViewController()

        return DriverNavigationController(transportsListVC: transportsListVC)
    }

    private func makeTransportListViewController() -> TransportsListViewController {
        return TransportsListViewController()
    }

    // Passenger
    private func makePassengerNavigationViewController() -> PassengerNavigationController {
        let passengerTransportRequestsVC = makePassengerTransportRequestsViewController()

        return PassengerNavigationController(passengerTransportRequestsVC: passengerTransportRequestsVC)
    }

    private func makePassengerTransportRequestsViewController() -> PassengerTransportRequestsViewController {
        let viewModel = makeUserTransportRequestsViewModel()
        let createRequestViewControllerFactory = {
            return self.makeCreateRequestViewController()
        }

        return PassengerTransportRequestsViewController(viewModel: viewModel,
                                                        createRequestViewControllerFactory: createRequestViewControllerFactory)
    }

    private func makeUserTransportRequestsViewModel() -> UserTransportRequestsViewModel {
        return UserTransportRequestsViewModel(transportRequestsRepository: sharedTransportRequestsRepository)
    }

    private func makeCreateRequestViewController() -> CreateRequestViewController {
        let viewModel = makeCreateRequestViewModel()

        return CreateRequestViewController(viewModel: viewModel)
    }

    private func makeCreateRequestViewModel() -> CreateRequestViewModel {
        return CreateRequestViewModel()
    }
    

}
