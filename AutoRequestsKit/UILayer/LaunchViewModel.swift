//
//  LaunchViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation

public final class LaunchViewModel {

    // MARK: - Private Properties
    private let userSessionRepository: UserSessionRepository
    private let notSignedInResponder: NotSignedInResponder
    private let signedInResponder: SignedInResponder

    // MARK: - Initializers
    public init(userSessionRepository: UserSessionRepository,
                notSignedInResponder: NotSignedInResponder,
                signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.notSignedInResponder = notSignedInResponder
        self.signedInResponder = signedInResponder
    }

    // MARK: - Public Methods
    public func loadUserSession() {
        userSessionRepository.readUserSession()
            .done(goToNextScreen(with:))
            .catch({ (error) in
                print("Error reading saved session: \(error.localizedDescription)")
            })
    }

    // MARK: - Private Methods
    private func goToNextScreen(with userSession: UserSession?) {
        if let userSession = userSession {
            signedInResponder.handleSignedIn(to: userSession)
        } else {
            notSignedInResponder.handleNotSignedIn()
        }
    }

}
