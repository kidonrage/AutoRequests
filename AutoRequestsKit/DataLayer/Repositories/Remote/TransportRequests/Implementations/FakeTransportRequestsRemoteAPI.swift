//
//  FakeTransportRequestsRemoteAPI.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import PromiseKit

public final class FakeTransportRequestsRemoteAPI: TransportRequestsRemoteAPI {

    // MARK: - Private Properties
    private let userSession: UserSession

    // MARK: - Initializers
    public init(userSession: UserSession) {
        self.userSession = userSession
    }

    // MARK: - Public Methods
    public func getTransportRequestsForCurrentUser() -> Promise<[TransportRequest]> {
        switch userSession.profile.type {
        case .driver:
            return getTransportRequestsForDriver()
        case .passenger:
            return getTransportRequestsForPassenger()
        }
    }

    private func getTransportRequestsForDriver() -> Promise<[TransportRequest]> {
        return Promise<[TransportRequest]> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                seal.fulfill([
                    TransportRequest(passengerId: 0, address: ""),
                    TransportRequest(passengerId: 1, address: ""),
                ])
            }
        }
    }

    private func getTransportRequestsForPassenger() -> Promise<[TransportRequest]> {
        return Promise<[TransportRequest]> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                seal.fulfill([
                    TransportRequest(passengerId: 0, address: ""),
                    TransportRequest(passengerId: 1, address: ""),
                    TransportRequest(passengerId: 2, address: ""),
                    TransportRequest(passengerId: 3, address: ""),
                ])
            }
        }
    }

}
