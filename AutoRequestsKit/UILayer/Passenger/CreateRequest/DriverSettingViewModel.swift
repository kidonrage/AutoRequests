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
        Driver(_id: 0, login: "driver", firstName: "Test", lastName: "Testov", patronymic: "Testovich", type: .driver),
        Driver(_id: 1, login: "driver", firstName: "Test", lastName: "Testov 2", patronymic: "Testovich", type: .driver)
    ])

    public func handleSelectDriver(on indexPath: IndexPath) {
        guard let drivers = try? driverOptions.value() else { return }

        let updatedSelectedDriver = drivers[indexPath.row]

        selectedDriver.onNext(updatedSelectedDriver)

        // TODO: Убрать бутафорскую машину
        selectedCar.onNext(Car(id: 0, name: "Toyota Camry 3.5", govNumber: "АБВ092В", driverId: updatedSelectedDriver._id))
    }

}
