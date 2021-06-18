//
//  UserProfile.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation

public class UserProfile: BaseUser {

    // MARK: - Public Properties
    public let type: UserType

    // MARK: - Initializers
    public init(id: String,
                firstName: String,
                lastName: String,
                patronymic: String?,
                mobileNumber: String,
                type: UserType) {
        self.type = type

        super.init(id: id, firstName: firstName, lastName: lastName, patronymic: patronymic, mobileNumber: mobileNumber)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

}
