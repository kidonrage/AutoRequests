//
//  AutoRequestsAppDependencyContainer.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import AutoRequestsKit

public final class AutoRequestsAppDependencyContainer {

    // MARK: - Private Properties
    let sharedUserSessionRepository: UserSessionRepository
    let sharedMainViewModel: MainViewModel

    // MARK: - Initializers
    public init() {
        func makeUserSessionRepository() -> UserSessionRepository {
            let dataStore = makeUserSessionDataStore()
            let remoteAPI = makeAuthRemoteAPI()

            return AutoRequestsUserSessionRepository(dataStore: dataStore,
                                                     remoteAPI: remoteAPI)
        }

        func makeUserSessionDataStore() -> UserSessionDataStore {
            return FakeUserSessionDataStore(hasToken: false)
        }

        func makeAuthRemoteAPI() -> AuthRemoteAPI {
            return FakeAuthRemoteAPI()
        }

        func makeViewModel() -> MainViewModel {
            return MainViewModel()
        }

        self.sharedUserSessionRepository = makeUserSessionRepository()
        self.sharedMainViewModel = makeViewModel()
    }

    // MARK: - Public Methods
    // Main
    public func makeMainViewController() -> MainViewController {
        let launchViewController = makeLaunchViewController()

        let signInViewControllerFactory = {
            return self.makeSignInViewController()
        }

        let signedInViewControllerFactory = { (userSession: UserSession) in
            return self.makeSignedInViewController(userSession: userSession)
        }



        return MainViewController(viewModel: sharedMainViewModel,
                                  launchViewController: launchViewController,
                                  signInViewControllerFactory: signInViewControllerFactory,
                                  signedInViewControllerFactory: signedInViewControllerFactory)
    }

    // Launching
    private func makeLaunchViewController() -> LaunchViewController {
        let viewModel = makeLaunchViewModel()

        return LaunchViewController(viewModel: viewModel)
    }

    private func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel(userSessionRepository: sharedUserSessionRepository,
                               notSignedInResponder: sharedMainViewModel,
                               signedInResponder: sharedMainViewModel)
    }

    // Sign In
    private func makeSignInViewController() -> SignInViewController {
        let viewModel = makeSignInViewModel()

        return SignInViewController(viewModel: viewModel)
    }

    private func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(userSessionRepository: sharedUserSessionRepository,
                               signedInResponder: sharedMainViewModel)
    }

    // Signed In
    private func makeSignedInViewController(userSession: UserSession) -> SignedInViewController {
        let viewModel = makeSignedInViewModel(userSession: userSession)

        return SignedInViewController(viewModel: viewModel,
                                      driverNavigationVCFactory: makeDriverNavigationViewController,
                                      passengerNavigationVCFactory: makePassengerNavigationViewController)
    }

    private func makeSignedInViewModel(userSession: UserSession) -> SignedInViewModel {
        return SignedInViewModel(userSession: userSession)
    }

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
