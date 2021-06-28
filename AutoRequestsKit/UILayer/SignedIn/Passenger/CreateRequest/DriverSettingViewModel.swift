//
//  DriverSettingViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxSwift
import RxRelay

public final class DriverSettingViewModel {

    public let selectedDriver = BehaviorRelay<Driver?>(value: nil)
    public let driverOptions = BehaviorRelay<[Driver]>(value: [
        Driver.getFake()
    ])

    public func handleSelectDriver(on indexPath: IndexPath) {
        let updatedSelectedDriver = driverOptions.value[indexPath.row]

        selectedDriver.accept(updatedSelectedDriver)
    }

}
