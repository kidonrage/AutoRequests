//
// TransportApplicationResponsePassenger.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct TransportApplicationResponsePassenger: Codable {

    public var _id: Int64?
    public var name: String?
    public var phone: String?

    public init(_id: Int64? = nil, name: String? = nil, phone: String? = nil) {
        self._id = _id
        self.name = name
        self.phone = phone
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case name
        case phone
    }

}
