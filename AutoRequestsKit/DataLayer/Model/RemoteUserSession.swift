//
//  RemoteUserSession.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation

public struct RemoteUserSession {

    // MARK: - Public Properties
    public let accessToken: String
    public let refreshToken: String

    // MARK: - Public Methods
    public static func getFake() -> RemoteUserSession {
        return RemoteUserSession(accessToken: "000000", refreshToken: "111111")
    }

}
