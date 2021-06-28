//
//  FakeAuthRemoteAPI.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import PromiseKit

public class FakeAuthRemoteAPI: AuthRemoteAPI {

    // MARK: - Initializers
    public init() {}

    // MARK: - Public Methods
    public func signIn(login: String, password: String) -> Promise<UserSession> {
        let isDriver = login == "driver" && password == "driver"
        let isPassenger = login == "passenger" && password == "passenger"

        if isPassenger {
            return signInAsPassenger()
        } else if isDriver {
            return signInAsDriver()
        } else {
            return Promise(error: NSError(domain: "test.auth", code: 0, userInfo: nil))
        }
    }

    // MARK: - Private Methods
    private func signInAsDriver() -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let profile = User(id: "driver",
                                   firstName: "Driver",
                                   lastName: "Driverov",
                                   patronymic: "Driverovich",
                                   mobileNumber: "+9 (999) 99-99-99",
                                   type: .driver)
                let remoteUserSession = RemoteUserSession.getFake()
                let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
                seal.fulfill(userSession)
            }
        }
    }

    private func signInAsPassenger() -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let profile = User(id: "passenger",
                                   firstName: "Passenger",
                                   lastName: "Passengerov",
                                   patronymic: "Passengerovich",
                                   mobileNumber: "+9 (999) 99-99-99",
                                   type: .passenger)
                let remoteUserSession = RemoteUserSession.getFake()
                let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
                seal.fulfill(userSession)
            }
        }
    }

}
