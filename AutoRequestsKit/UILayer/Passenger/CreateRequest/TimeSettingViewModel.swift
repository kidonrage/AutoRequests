//
//  TimeSettingViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxSwift

public final class TimeSettingViewModel {

    public let selectedStartTime = BehaviorSubject<Date>(value: Date())
    public let selectedEndTime = BehaviorSubject<Date>(value: Date())

}
