//
//  AuthViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import RxSwift
import RxRelay

public class SignInViewModel {

    // MARK: - Private Properties
    private let userSessionRepository: UserSessionRepository

    // MARK: - Public Properties
    public let isSignInButtonEnabled: Observable<Bool>
    public let login = BehaviorRelay<String>(value: "")
    public let password = BehaviorRelay<String>(value: "")

    // MARK: - Initializers
    public init(userSessionRepository: UserSessionRepository) {
        self.userSessionRepository = userSessionRepository

        isSignInButtonEnabled = Observable.combineLatest(login, password).map { !$0.isEmpty && !$1.isEmpty }
    }

    // MARK: - Public Properties
    @objc
    public func signIn() {
        userSessionRepository.signIn(login: login.value, password: password.value)
            .done { (userSession) in
                print("Logged In \(userSession.profile.name) with id \(userSession.profile.id)")
            }
            .catch { (error) in
                print("Error logging in \(error.localizedDescription)")
            }
    }

}
