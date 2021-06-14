//
//  DateSettingViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxSwift

public final class DateSettingViewModel {

    public let selectedDate = BehaviorSubject<Date>(value: Date())

}
