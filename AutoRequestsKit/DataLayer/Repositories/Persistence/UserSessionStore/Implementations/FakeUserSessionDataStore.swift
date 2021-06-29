//
//  FakeUserSessionDataStore.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import PromiseKit

public class FakeUserSessionDataStore: UserSessionDataStore {

    // MARK: - Properties
    let tokenSavedForUserType: UserType?

    // MARK: - Methods
    public init(tokenSavedForUserType: UserType?) {
        self.tokenSavedForUserType = tokenSavedForUserType
    }

    public func save(userSession: UserSession) -> Promise<(UserSession)> {
        return .value(userSession)
    }

    public func delete(userSession: UserSession) -> Promise<(UserSession)> {
        return .value(userSession)
    }

    public func readUserSession() -> Promise<UserSession?> {
        guard let tokenSavedForUserType = self.tokenSavedForUserType else {
            return runDoesNotHaveToken()
        }

        switch tokenSavedForUserType {
        case .passenger:
            return runPassengerHasToken()
        case .driver:
            return runDriverHasToken()
        }
    }

    public func runPassengerHasToken() -> Promise<UserSession?> {
        let profile = User(id: "passenger", firstName: "Test", lastName: "User", patronymic: "Passenger", mobileNumber: "+9 (999) 999-99-99", type: .passenger)
        let remoteSession = RemoteUserSession.getFake()
        return .value(UserSession(profile: profile, remoteSession: remoteSession))
    }

    public func runDriverHasToken() -> Promise<UserSession?> {
        let profile = User(id: "driver", firstName: "Test", lastName: "User", patronymic: "Driver", mobileNumber: "+9 (999) 999-99-99", type: .driver)
        let remoteSession = RemoteUserSession.getFake()
        return .value(UserSession(profile: profile, remoteSession: remoteSession))
    }

    func runDoesNotHaveToken() -> Promise<UserSession?> {
        return .value(nil)
    }
}
