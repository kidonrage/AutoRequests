//
//  MyRequestsViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 23.05.2021.
//

import UIKit

class MyRequestsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
    }

    @objc private func add() {
        let createRequestVC = CreateRequestViewController(viewModel: CreateRequestViewModel())

        navigationController?.pushViewController(createRequestVC, animated: true)
    }

}
