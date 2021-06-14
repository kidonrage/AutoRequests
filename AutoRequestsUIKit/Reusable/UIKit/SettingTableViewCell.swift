//
//  SettingTableViewCell.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 12.06.2021.
//

import UIKit

public class SettingTableViewCell: UITableViewCell {


    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UITableViewCell
    public override func setSelected(_ selected: Bool, animated: Bool) {
        contentView.backgroundColor = selected ? UIColor(white: 0.95, alpha: 1.0) : .white
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let contentViewFrame = self.contentView.frame
        let insetContentViewFrame = contentViewFrame.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        self.contentView.frame = insetContentViewFrame
    }

}
