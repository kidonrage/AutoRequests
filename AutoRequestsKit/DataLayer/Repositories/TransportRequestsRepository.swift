//
//  TransportRequestsRepository.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import PromiseKit

public protocol TransportRequestsRepository {

    func getTransportRequestsForCurrentUser() -> Promise<[TransportApplication]>
    func saveTransportRequest(request: TransportApplicationRequest) -> Promise<Void>

}
