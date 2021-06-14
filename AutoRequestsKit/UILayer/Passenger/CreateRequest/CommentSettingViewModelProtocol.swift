//
//  CommentSettingViewModelProtocol.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import RxSwift

public protocol CommentSettingViewModelProtocol {

    var comment: BehaviorSubject<String?> { get }

}
