//
//  TransportRequestsRemoteAPI.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import PromiseKit

public protocol TransportRequestsRemoteAPI {

    func getTransportRequestsForCurrentUser() -> Promise<[TransportRequest]>

}
