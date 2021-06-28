//
//  AutoRequestsDriversRepository.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 28.06.2021.
//

import Foundation
import PromiseKit

public final class AutoRequestsDriversRepository: DriversRepository {

    // MARK: - Private Properties
    private let remoteAPI: DriversRemoteAPI

    // MARK: - Initializers
    public init(remoteAPI: DriversRemoteAPI) {
        self.remoteAPI = remoteAPI
    }

    // MARK: - Public Methods
    public func getAvailableDrivers(dateString: String) -> Promise<[Driver]> {
        return remoteAPI.getAvailableDrivers(dateString: dateString)
    }

    public func getAvailableTimeRangesForDriver(withId driverId: String, onDateString dateString: String) -> Promise<[String]> {
        return remoteAPI.getAvailableTimeRangesForDriver(withId: driverId, onDateString: dateString)
    }

}
