//
//  AutoRequestsCloudTransportRequestsRemoteAPI.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 28.06.2021.
//

import Foundation
import Alamofire
import PromiseKit

public final class AutoRequestsCloudTransportRequestsRemoteAPI: TransportRequestsRemoteAPI {

    // MARK: - Private Properties
    private let domain = "localhost"
    private let port = 5000
    private let userSession: UserSession

    // MARK: - Initializers
    public init(userSession: UserSession) {
        self.userSession = userSession
    }

    // MARK: - Public Methods
    public func getTransportRequestsForCurrentUser() -> Promise<[TransportApplication]> {
        return Promise<[TransportApplication]> { seal in
            let request = AF.request("http://\(domain):\(port)/api/transportApplications", method: .get, headers: [
                "Authorization": "Bearer \(userSession.remoteSession.accessToken)"
            ])
            DispatchQueue.global().async {
                request.responseDecodable(completionHandler: { (response: DataResponse<[TransportApplication], AFError>) in
                    switch response.result {
                    case .success(let transportApplications):
                        DispatchQueue.main.async {
                            seal.fulfill(transportApplications)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            seal.reject(error)
                        }
                    }
                })
            }
        }
    }

    public func saveTransportRequest(request: TransportApplicationRequest) -> Promise<Void> {
        return Promise<Void> { seal in
            let parameters: [String : String?] = [
                "passengerId": request.passengerId,
                "driverId": request.driverId,
                "address": request.address,
                "date": request.date,
                "timeRange": request.timeRange,
                "comment": request.comment,
            ]

            let request = AF.request("http://\(domain):\(port)/api/transportApplications", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: [
                "Authorization": "Bearer \(userSession.remoteSession.accessToken)"
            ])

            request.response { (response) in
                switch response.result {
                case .success:
                    seal.fulfill(())
                case .failure(let error):
                    print(error)
                    seal.reject(error)
                }
            }
        }
    }

}
