//
//  Passenger.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 18.06.2021.
//

import Foundation

public struct Passenger: Decodable {

    // MARK: - Public Properties
    public let id: String?
    public let firstName: String
    public let lastName: String
    public let patronymic: String?
    public let mobileNumber: String

    public var displayName: String {
        return "\(lastName) \(firstName)\(patronymic != nil ? " \(patronymic!)" : "")"
    }

    // MARK: - Public Methods
    public static func getFake() -> Passenger {
        return Passenger(id: "fakePassenger", firstName: "Passenger", lastName: "Passengerov", patronymic: "Passengerovich", mobileNumber: "+9 (999) 999-99-99")
    }

}
