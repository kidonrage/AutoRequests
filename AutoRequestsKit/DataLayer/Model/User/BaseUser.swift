//
//  BaseUser.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 18.06.2021.
//

import Foundation

open class BaseUser: Decodable {

    // MARK: - Public Properties
    public let id: String
    public let firstName: String
    public let lastName: String
    public let patronymic: String?
    public let mobileNumber: String

    public init(id: String,
                firstName: String,
                lastName: String,
                patronymic: String?,
                mobileNumber: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.patronymic = patronymic
        self.mobileNumber = mobileNumber
    }

}
