//
//  AutoRequestsCloudAuthenticationRemoteAPI.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 24.06.2021.
//

import Foundation
import PromiseKit
import Alamofire

public final class AutoRequestsCloudAuthRemoteAPI: AuthRemoteAPI {

    // MARK: - Private Properties
    private let domain = "localhost"
    private let port = 5000

    // MARK: - Initializers
    public init() {}

    // MARK: - Public Methods
    public func signIn(login: String, password: String) -> Promise<UserSession> {
        return Promise<UserSession> { (seal) in
            let parameters: [String : String] = [
                "login": login,
                "password": password
            ]

            let request = AF.request("http://\(domain):\(port)/api/auth/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder())

            request.responseDecodable(completionHandler: { (response: DataResponse<LoginResponse, AFError>) in
                switch response.result {
                case .success(let loginResponse):
                    let remoteSession = RemoteUserSession(accessToken: loginResponse.accessToken,
                                                          refreshToken: loginResponse.refreshToken)
                    let session = UserSession(profile: loginResponse.user,
                                              remoteSession: remoteSession)
                    seal.fulfill(session)
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }

}
