//
//  DateSettingViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxSwift
import RxRelay

public final class DateSettingViewModel {

    public let selectedDate = BehaviorRelay<Date>(value: Date())

}
