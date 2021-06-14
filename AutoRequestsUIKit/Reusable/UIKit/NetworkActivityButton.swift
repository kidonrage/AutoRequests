//
//  NetworkActivityButton.swift
//  AutoRequestsUIKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import UIKit

open class NetworkActivityButton: UIButton {

    // MARK: - Visual Components
    private let activityIndicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        indicator.color = .white
        indicator.hidesWhenStopped = true

        return indicator
    }()

    // MARK: - UIButton
    open override func didMoveToWindow() {
        super.didMoveToWindow()

        addSubview(activityIndicator)

        activateConstraintsSignInActivityIndicator()
    }

    // MARK: - Public Methods
    public func setActivityIndicatorActive(_ isActive: Bool) {
        if isActive {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        self.titleLabel?.layer.opacity = isActive ? 0.0 : 1.0
        self.isEnabled = !isActive
    }

    // MARK: - Private Methods
    private func activateConstraintsSignInActivityIndicator() {
        let centerX = activityIndicator.centerXAnchor
            .constraint(equalTo: self.centerXAnchor)
        let centerY = activityIndicator.centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate(
            [centerX, centerY])
    }

}
