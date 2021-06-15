//
//  DriverOptionTableViewCell.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import UIKit

final class DriverOptionTableViewCell: UITableViewCell {

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constants
    static let cellId = "DriverOptionTableViewCell"

}
