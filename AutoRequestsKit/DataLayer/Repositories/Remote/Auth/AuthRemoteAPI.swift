//
//  AuthRemoteAPI.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import PromiseKit

public protocol AuthRemoteAPI {

    func signIn(login: String, password: String) -> Promise<UserSession>

}
