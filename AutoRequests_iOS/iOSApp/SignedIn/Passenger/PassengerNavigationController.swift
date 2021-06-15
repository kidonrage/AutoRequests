//
//  PassengerNavigationController.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import UIKit

public final class PassengerNavigationController: UINavigationController {

    private let createRequestVC: CreateRequestViewController

    public init(createRequestVC: CreateRequestViewController) {
        self.createRequestVC = createRequestVC

        super.init(rootViewController: createRequestVC)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
