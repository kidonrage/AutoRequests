//
//  SignedInResponder.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation

public protocol SignedInResponder {

    func handleSignedIn(to userSession: UserSession)

}
