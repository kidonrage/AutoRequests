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
    public let driverOptions = BehaviorSubject<[Driver]>(value: [
        Driver.getFake()
    ])

    public func handleSelectDriver(on indexPath: IndexPath) {
        guard let drivers = try? driverOptions.value() else { return }

        let updatedSelectedDriver = drivers[indexPath.row]

        selectedDriver.onNext(updatedSelectedDriver)
    }

}
