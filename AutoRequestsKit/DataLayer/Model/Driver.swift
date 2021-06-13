//
// Driver.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct Driver: Codable {

    public enum ModelType: String, Codable { 
        case driver = "driver"
        case passenger = "passenger"
    }
    public var _id: Int64?
    /** Отчество */
    public var login: String?
    public var firstName: String?
    public var lastName: String?
    /** Отчество */
    public var patronymic: String?
    /** Тип пользователя в системе */
    public var type: ModelType?

    public var displayName: String {
        return (lastName ?? "Unknown") + " " + (firstName ?? "Unknown")
    }

    public init(_id: Int64? = nil, login: String? = nil, firstName: String? = nil, lastName: String? = nil, patronymic: String? = nil, type: ModelType? = nil) {
        self._id = _id
        self.login = login
        self.firstName = firstName
        self.lastName = lastName
        self.patronymic = patronymic
        self.type = type
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case login
        case firstName
        case lastName
        case patronymic
        case type
    }

}
