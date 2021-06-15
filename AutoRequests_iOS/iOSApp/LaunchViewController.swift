//
//  LaunchViewController.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import AutoRequestsUIKit
import AutoRequestsKit

public final class LaunchViewController: NiblessViewController {

    // MARK: - Private Properties
    private let viewModel: LaunchViewModel

    // MARK: - Initializers
    public init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel

        super.init()

        loadUserSession()
    }

    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Private Methods
    private func loadUserSession() {
        viewModel.loadUserSession()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
    }

}
