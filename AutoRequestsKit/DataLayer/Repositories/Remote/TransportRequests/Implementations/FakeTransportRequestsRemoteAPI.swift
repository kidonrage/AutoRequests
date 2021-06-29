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
    public func getTransportRequestsForCurrentUser() -> Promise<[TransportApplication]> {
        switch userSession.profile.type {
        case .driver:
            return getTransportRequestsForDriver()
        case .passenger:
            return getTransportRequestsForPassenger()
        }
    }

    public func saveTransportRequest(request: TransportApplicationRequest) -> Promise<Void> {
        return Promise<Void> { seal in
            seal.fulfill(())
        }
    }

    // MARK: - Private Methods
    private func getTransportRequestsForDriver() -> Promise<[TransportApplication]> {
        return Promise<[TransportApplication]> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                seal.fulfill([
                    TransportApplication.getFake(),
                    TransportApplication.getFake(),
                ])
            }
        }
    }

    private func getTransportRequestsForPassenger() -> Promise<[TransportApplication]> {
        return Promise<[TransportApplication]> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                seal.fulfill([
                    TransportApplication.getFake(),
                    TransportApplication.getFake(),
                    TransportApplication.getFake(),
                    TransportApplication.getFake(),
                ])
            }
        }
    }

}
