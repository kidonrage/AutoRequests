//
//  DriverSettingViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxSwift
import RxRelay

public protocol DriverSettingViewModelProtocol {

    var selectedDriver: BehaviorRelay<Driver?> { get }
    var driverOptions: BehaviorRelay<[Driver]> { get }

    func handleSelectDriver(on indexPath: IndexPath)

}
