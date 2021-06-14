//
// TransportApplicationRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct TransportApplicationRequest: Codable {

    public var passengerId: Int64
    public var driverId: Int64?
    public var address: String
    public var timestampStart: Int?
    public var timestampEnd: Int?
    public var comment: String?

    public init(passengerId: Int64, driverId: Int64? = nil, address: String, timestampStart: Int? = nil, timestampEnd: Int? = nil, comment: String? = nil) {
        self.passengerId = passengerId
        self.driverId = driverId
        self.address = address
        self.timestampStart = timestampStart
        self.timestampEnd = timestampEnd
        self.comment = comment
    }


}
