//
//  MainView.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation

public enum MainView {
    case launching
    case signIn
    case signedIn(userSession: UserSession)
}
