//
//  MainViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import RxRelay

public final class MainViewModel: NotSignedInResponder, SignedInResponder {

    // MARK: - Public Properties
    public let view = BehaviorRelay<MainView>(value: .launching)

    // MARK: - Initializers
    public init() {}

    // MARK: - Public Methods
    public func handleNotSignedIn() {
        view.accept(.signIn)
    }

    public func handleSignedIn(to userSession: UserSession) {
        view.accept(.signedIn(userSession: userSession))
    }

}
