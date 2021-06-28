//
//  AutoRequestsCloudDriversRemoteAPI.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 28.06.2021.
//

import Foundation
import Alamofire
import PromiseKit

public final class AutoRequestsCloudDriversRemoteAPI: DriversRemoteAPI {

    // MARK: - Private Properties
    private let domain = "localhost"
    private let port = 5000
    private let userSession: UserSession

    // MARK: - Initializers
    public init(userSession: UserSession) {
        self.userSession = userSession
    }

    // MARK: - Public Methods
    public func getAvailableDrivers(dateString: String) -> Promise<[Driver]> {
        return Promise<[Driver]> { seal in
            let parameters = [
                "date": dateString
            ]

            let request = AF.request("http://\(domain):\(port)/api/drivers/available", method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder(), headers: [
                "Authorization": "Bearer \(userSession.remoteSession.accessToken)"
            ])

            request.responseDecodable(completionHandler: { (response: DataResponse<[Driver], AFError>) in
                switch response.result {
                case .success(let drivers):
                    seal.fulfill(drivers)
                case .failure(let error):
                    print(error)
                    seal.reject(error)
                }
            })
        }
    }

    public func getAvailableTimeRangesForDriver(withId driverId: String, onDateString dateString: String) -> Promise<[String]> {
        return Promise<[String]> { seal in
            let parameters = [
                "date": dateString
            ]

            let request = AF.request("http://\(domain):\(port)/api/drivers/\(driverId)/timeAvailable", method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder(), headers: [
                "Authorization": "Bearer \(userSession.remoteSession.accessToken)"
            ])

            request.responseDecodable(completionHandler: { (response: DataResponse<[String], AFError>) in
                switch response.result {
                case .success(let timeRanges):
                    seal.fulfill(timeRanges)
                case .failure(let error):
                    print(error)
                    seal.reject(error)
                }
            })
        }
    }

}
