//
//  DateSettingViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxRelay

public protocol DateSettingViewModelProtocol {

    var selectedDate: BehaviorRelay<Date> { get }

}
