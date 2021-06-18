//
//  Car.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 18.06.2021.
//

import Foundation

public struct Car: Decodable {

    /** ID машины в базе */
    public let id: String
    /** Название */
    public var name: String
    /** Гос номер */
    public var govNumber: String
    /** ID водителя к которому привязана машина */
    public let driverId: String

    public static func getFake() -> Car {
        return Car(id: "testCar", name: "Toyota Camry 3.5 2010", govNumber: "С065МК", driverId: "testDriver")
    }

}
