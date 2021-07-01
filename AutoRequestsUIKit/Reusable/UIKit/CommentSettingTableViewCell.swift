//
//  CommentSettingTableViewCell.swift
//  AutoRequestsUIKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import UIKit
import RxSwift

import AutoRequestsKit

public final class CommentSettingTableViewCell: SettingTableViewCell {

    // MARK: - Visual Components
    private let commentIconView = SettingIconView(imageSystemName: "bubble.right", backgroundColor: .systemGray)
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарий"
        return label
    }()
    private let commentTextView: UITextView = {
        let field = UITextView()
        field.isEditable = true
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 4
        return field
    }()
    private lazy var commentView: UIStackView = {
        let commentIcon = UIStackView(arrangedSubviews: [UIView(), commentIconView, UIView()])
        commentIcon.axis = .vertical
        commentIcon.distribution = .equalCentering

        let headerView = UIStackView(arrangedSubviews: [commentIcon, commentLabel])
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.axis = .horizontal
        headerView.spacing = 8

        let stackView = UIStackView(arrangedSubviews: [headerView, commentTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    // MARK: - Private Properties
    private var viewModel: CommentSettingViewModelProtocol!
    private let bag = DisposeBag()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(commentView)

        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            commentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            commentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            commentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            commentIconView.widthAnchor.constraint(equalToConstant: 40),
            commentIconView.heightAnchor.constraint(equalTo: commentIconView.widthAnchor),

            commentTextView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITableView
    public override func setSelected(_ selected: Bool, animated: Bool) {
        return
    }

    // MARK: - Public Methods
    public func configure(with viewModel: CommentSettingViewModelProtocol) {
        self.viewModel = viewModel

        bindViewModel()
    }

    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.comment.bind(to: commentTextView.rx.text).disposed(by: bag)
        commentTextView.rx.text.bind(to: viewModel.comment).disposed(by: bag)
    }


    // MARK: - Constants
    public static let cellId = "CommentSettingTableViewCell"

}
