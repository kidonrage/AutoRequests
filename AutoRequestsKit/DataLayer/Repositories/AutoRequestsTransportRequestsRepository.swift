//
//  AutoRequestsTransportRequestsRepository.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import PromiseKit

public final class AutoRequestsTransportRequestsRepository: TransportRequestsRepository {

    // MARK: - Private Properties
    private let remoteAPI: TransportRequestsRemoteAPI

    // MARK: - Initializers
    public init(remoteAPI: TransportRequestsRemoteAPI) {
        self.remoteAPI = remoteAPI
    }

    // MARK: - Public Methods
    public func getTransportRequestsForCurrentUser() -> Promise<[TransportRequest]> {
        return remoteAPI.getTransportRequestsForCurrentUser()
    }


}
