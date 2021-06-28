//
//  CommentSettingViewModelProtocol.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import RxSwift
import RxRelay

public protocol CommentSettingViewModelProtocol {

    var comment: BehaviorRelay<String?> { get }

}
