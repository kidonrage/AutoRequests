//
//  UserSession.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import PromiseKit

public protocol UserSessionRepository {

    func readUserSession() -> Promise<UserSession?>
    func signIn(login: String, password: String) -> Promise<UserSession>
    func signOut(userSession: UserSession) -> Promise<UserSession>

}
