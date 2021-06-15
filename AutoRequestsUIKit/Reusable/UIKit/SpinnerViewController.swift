//
//  SpinnerViewController.swift
//  AutoRequestsUIKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import UIKit

public final class SpinnerViewController: NiblessViewController {

    var spinner = UIActivityIndicatorView(style: .large)

    public override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        spinner.color = .systemBackground

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
