//
//  AutoRequestsUserSessionRepository.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import PromiseKit

public class AutoRequestsUserSessionRepository: UserSessionRepository {

    // MARK: - Private Properties
    private let dataStore: UserSessionDataStore
    private let remoteAPI: AuthRemoteAPI

    // MARK: - Initializers
    public init(dataStore: UserSessionDataStore,
                remoteAPI: AuthRemoteAPI) {
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }

    public func readUserSession() -> Promise<UserSession?> {
        return dataStore.readUserSession()
    }

    public func signIn(login: String, password: String) -> Promise<UserSession> {
        return remoteAPI.signIn(login: login, password: password)
    }

    public func signOut(userSession: UserSession) -> Promise<UserSession> {
        return dataStore.delete(userSession: userSession)
    }

}
