//
//  SettingIconView.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 10.06.2021.
//

import UIKit

class SettingIconView: UIView {

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(imageSystemName: String, backgroundColor: UIColor) {
        super.init(frame: .zero)

        iconView.image = UIImage(systemName: imageSystemName)

        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 4

        addSubview(iconView)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalTo: widthAnchor, constant: -16),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
