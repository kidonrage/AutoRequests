//
//  Driver.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 18.06.2021.
//

import Foundation

public struct Driver: Decodable {

    // MARK: - Public Properties
    public let id: String?
    public let firstName: String
    public let lastName: String
    public let patronymic: String?
    public let mobileNumber: String
    public let car: Car

    public var displayName: String {
        return "\(lastName) \(firstName)\(patronymic != nil ? " \(patronymic!)" : "")"
    }

    // MARK: - Public Methods
    public static func getFake() -> Driver {
        return Driver(id: "fakeDriver", firstName: "Driver", lastName: "Driverov", patronymic: "Driverovich", mobileNumber: "+9 (999) 999-99-99", car: Car.getFake())
    }

}
