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
    func save(userSession: UserSession) -> Promise<UserSession>
    func delete(userSession: UserSession) -> Promise<UserSession>

}
