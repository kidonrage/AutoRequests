//
//  TimeSettingViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxSwift

public final class TimeSettingViewModel {

    public let timeOptions = BehaviorSubject<[String]>(value: ["13:00 – 14:00", "14:00 – 15:00"])
    public let selectedTimeIndex = BehaviorSubject<Int?>(value: nil)

}
