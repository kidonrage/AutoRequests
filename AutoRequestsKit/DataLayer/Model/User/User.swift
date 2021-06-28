//
//  User.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 18.06.2021.
//

import Foundation

public struct User: Decodable {

    // MARK: - Public Properties
    public let id: String
    public let firstName: String
    public let lastName: String
    public let patronymic: String?
    public let mobileNumber: String
    public let type: UserType

}

extension User {

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case patronymic
        case mobileNumber
        case type
    }

}
