//
//  DriverNavigationController.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import UIKit

public final class DriverNavigationController: UINavigationController {

    private let transportsListVC: TransportsListViewController

    public init(transportsListVC: TransportsListViewController) {
        self.transportsListVC = transportsListVC
        
        super.init(rootViewController: transportsListVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
