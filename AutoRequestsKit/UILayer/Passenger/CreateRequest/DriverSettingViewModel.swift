//
//  DriverSettingViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxSwift

public final class DriverSettingViewModel {

    public let selectedDriver = BehaviorSubject<Driver?>(value: nil)
    public let selectedCar = BehaviorSubject<Car?>(value: nil)
    public let driverOptions = BehaviorSubject<[Driver]>(value: [
        Driver(_id: 0, login: "driver", firstName: "Test", lastName: "Testov", patronymic: "Testovich", type: .driver)
    ])

}
