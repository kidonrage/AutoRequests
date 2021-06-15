//
//  SignedInViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import RxRelay

public final class SignedInViewModel {

    public let view: BehaviorRelay<SignedInView>

    public init(userSession: UserSession) {
        switch userSession.profile.type {
        case .passenger:
            self.view = BehaviorRelay(value: .passenger)
        case .driver:
            self.view = BehaviorRelay(value: .driver)
        }
    }

}
