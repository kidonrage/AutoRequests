//
//  UserSession.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation

public class UserSession {

    // MARK: - Public Properties
    public let profile: UserProfile
    public let remoteSession: RemoteUserSession

    // MARK: - Initializers
    public init(profile: UserProfile, remoteSession: RemoteUserSession) {
        self.profile = profile
        self.remoteSession = remoteSession
    }

}
