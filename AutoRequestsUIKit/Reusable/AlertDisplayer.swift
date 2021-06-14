//
//  AlertDisplayer.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 23.05.2021.
//

import UIKit

public protocol AlertDisplayer: class {

    func display(title: String?, message: String?, actions: [UIAlertAction]?)

}

public extension AlertDisplayer where Self: UIViewController {

    func display(title: String?, message: String?, actions: [UIAlertAction]?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let actions = actions {
            for action in actions {
                ac.addAction(action)
            }
        } else {
            ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        }

        self.present(ac, animated: true)
    }

}
