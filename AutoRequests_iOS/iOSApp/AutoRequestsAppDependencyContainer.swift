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
            return FakeUserSessionDataStore(tokenSavedForUserType: nil)
        }

        func makeAuthRemoteAPI() -> AuthRemoteAPI {
            return AutoRequestsCloudAuthRemoteAPI()
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
        let container = makeSignedInDependencyContainer(userSession: userSession)

        return container.makeSignedInViewController()
    }

    private func makeSignedInDependencyContainer(userSession: UserSession) -> AutoRequestsSignedInDependencyContainer {
        return AutoRequestsSignedInDependencyContainer(userSession: userSession,
                                                       appDependencyContainer: self)
    }
}
