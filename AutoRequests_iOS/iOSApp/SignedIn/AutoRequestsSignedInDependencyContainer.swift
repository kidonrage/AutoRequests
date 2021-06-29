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
    private let sharedDriversRepository: DriversRepository
    private let sharedTransportRequestsRepository: TransportRequestsRepository

    // MARK: - Initializers
    public init(userSession: UserSession, appDependencyContainer: AutoRequestsAppDependencyContainer) {
        func makeTransportRequestsRepository() -> TransportRequestsRepository {
            let remoteAPI = makeTransportRequestsRemoteAPI()

            return AutoRequestsTransportRequestsRepository(remoteAPI: remoteAPI)
        }

        func makeDriversRepository() -> DriversRepository {
            let remoteAPI = makeDriversRemoteAPI()

            return AutoRequestsDriversRepository(remoteAPI: remoteAPI)
        }

        func makeDriversRemoteAPI() -> DriversRemoteAPI {
            return AutoRequestsCloudDriversRemoteAPI(userSession: userSession)
        }

        func makeTransportRequestsRemoteAPI() -> TransportRequestsRemoteAPI {
            return AutoRequestsCloudTransportRequestsRemoteAPI(userSession: userSession)
        }

        func makeSignedInViewModel() -> SignedInViewModel {
            return SignedInViewModel(userSession: userSession)
        }

        self.sharedTransportRequestsRepository = makeTransportRequestsRepository()
        self.sharedDriversRepository = makeDriversRepository()
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
        let driverContainer = makeDriverDependencyContainer()

        return driverContainer.makeDriverNavigationViewController()
    }

    private func makeDriverDependencyContainer() -> AutoRequestsDriverDependencyContainer {
        return AutoRequestsDriverDependencyContainer(transportRequestsRepository: sharedTransportRequestsRepository)
    }

    // Passenger
    private func makePassengerNavigationViewController() -> PassengerNavigationController {
        let passengerContainer = makePassengerDependencyContainer()

        return passengerContainer.makePassengerNavigationViewController()
    }

    private func makePassengerDependencyContainer() -> AutoRequestsPassengerDependencyContainer {
        return AutoRequestsPassengerDependencyContainer(
            userSession: userSession,
            transportRequestsRepository: sharedTransportRequestsRepository,
            driversRepository: sharedDriversRepository)
    }

}
