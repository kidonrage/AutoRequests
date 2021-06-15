//
//  TransportsListViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 23.05.2021.
//

import UIKit
import AutoRequestsUIKit

public final class TransportsListViewController: NiblessViewController {

    private let transportsListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(transportsListTableView)

        NSLayoutConstraint.activate([
            transportsListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            transportsListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transportsListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transportsListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}
