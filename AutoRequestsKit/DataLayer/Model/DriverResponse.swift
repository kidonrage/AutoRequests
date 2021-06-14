//
// DriverResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct DriverResponse: Codable {

    public var driver: Driver?
    public var car: Car?

    public init(driver: Driver? = nil, car: Car? = nil) {
        self.driver = driver
        self.car = car
    }


}
