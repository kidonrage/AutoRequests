//
//  DriversRepository.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 28.06.2021.
//

import Foundation
import PromiseKit

public protocol DriversRepository {

    func getAvailableDrivers(dateString: String) -> Promise<[Driver]>

}
