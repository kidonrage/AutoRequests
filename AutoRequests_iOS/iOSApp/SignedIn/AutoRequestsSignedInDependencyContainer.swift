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

    // MARK: - Initializers
    public init(userSession: UserSession, appDependencyContainer: AutoRequestsAppDependencyContainer) {
        func makeSignedInViewModel() -> SignedInViewModel {
            return SignedInViewModel(userSession: userSession)
        }

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
        let createRequestVC = makeCreateRequestViewController()

        return PassengerNavigationController(createRequestVC: createRequestVC)
    }

    private func makeCreateRequestViewController() -> CreateRequestViewController {
        let viewModel = makeCreateRequestViewModel()

        return CreateRequestViewController(viewModel: viewModel)
    }

    private func makeCreateRequestViewModel() -> CreateRequestViewModel {
        return CreateRequestViewModel()
    }

}