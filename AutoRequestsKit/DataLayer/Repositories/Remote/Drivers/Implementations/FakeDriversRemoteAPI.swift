//
//  FakeDriversRemoteAPI.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 07.03.2023.
//

import Foundation
import Alamofire
import PromiseKit

public final class FakeDriversRemoteAPI: DriversRemoteAPI {
    
    public init() {}
    
    public func getAvailableDrivers(dateString: String) -> PromiseKit.Promise<[Driver]> {
        return Promise<[Driver]> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                seal.fulfill([
                    Driver.getFake(),
                ])
            }
        }
    }
    
    public func getAvailableTimeRangesForDriver(withId driverId: String, onDateString dateString: String) -> PromiseKit.Promise<[String]> {
        return Promise<[String]> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                seal.fulfill([
                    "11:00-12:00",
                    "15:00-16:00",
                ])
            }
        }
    }
}
