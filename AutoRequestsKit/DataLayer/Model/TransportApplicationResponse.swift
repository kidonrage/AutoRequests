//
// TransportApplicationResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct TransportApplicationResponse: Codable {

    public var passenger: TransportApplicationResponsePassenger?
    public var driver: TransportApplicationResponseDriver?
    public var address: String?
    public var timestampStart: Int?
    public var timestampEnd: Int?
    public var comment: String?

    public init(passenger: TransportApplicationResponsePassenger? = nil, driver: TransportApplicationResponseDriver? = nil, address: String? = nil, timestampStart: Int? = nil, timestampEnd: Int? = nil, comment: String? = nil) {
        self.passenger = passenger
        self.driver = driver
        self.address = address
        self.timestampStart = timestampStart
        self.timestampEnd = timestampEnd
        self.comment = comment
    }


}
