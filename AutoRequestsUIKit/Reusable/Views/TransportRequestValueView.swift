//
//  TransportRequestValueView.swift
//  AutoRequestsUIKit
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import UIKit

public final class TransportRequestValueView: UIStackView {

    // MARK: - Visual Components
    private let valueNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
//        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    // MARK: - Public Properties
    public var valueName: String {
        didSet {
            valueNameLabel.text = valueName
        }
    }
    public var value: String? {
        didSet {
            valueLabel.text = value ?? "–"
        }
    }

    public init(valueName: String, value: String?) {
        self.valueName = valueName
        self.value = value

        super.init(frame: .zero)

        valueNameLabel.text = valueName
        valueLabel.text = value ?? "–"

        self.addArrangedSubview(valueNameLabel)
        self.addArrangedSubview(valueLabel)

        self.axis = .vertical
        self.spacing = 4
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
