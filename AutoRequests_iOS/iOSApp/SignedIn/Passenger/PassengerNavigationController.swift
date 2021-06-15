//
//  PassengerNavigationController.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import UIKit

public final class PassengerNavigationController: UINavigationController {

    private let passengerTransportRequestsVC: PassengerTransportRequestsViewController

    public init(passengerTransportRequestsVC: PassengerTransportRequestsViewController) {
        self.passengerTransportRequestsVC = passengerTransportRequestsVC

        super.init(rootViewController: passengerTransportRequestsVC)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
