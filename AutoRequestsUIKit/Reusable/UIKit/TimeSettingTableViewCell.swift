//
//  TimeSettingTableViewCell.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 12.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

import AutoRequestsKit

public final class TimeSettingTableViewCell: SettingTableViewCell {

    // MARK: - Visual Components
    private let timeIconView = SettingIconView(imageSystemName: "timer", backgroundColor: .systemYellow)
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время поездки"
        return label
    }()
    private lazy var timePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    private lazy var timeViewText: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, timePicker])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private lazy var timeView: UIStackView = {
        let timeIcon = UIStackView(arrangedSubviews: [UIView(), timeIconView, UIView()])
        timeIcon.axis = .vertical
        timeIcon.distribution = .equalCentering

        let headerView = UIStackView(arrangedSubviews: [timeIcon, timeLabel])
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.axis = .horizontal
        headerView.spacing = 8

        let stackView = UIStackView(arrangedSubviews: [headerView, timePicker])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()


    // MARK: - Private Properties
    private var viewModel: TimeSettingViewModel!
    private let bag = DisposeBag()


    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(timeView)

        NSLayoutConstraint.activate([
            timeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            timeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            timePicker.heightAnchor.constraint(equalToConstant: 120),

            timeIconView.widthAnchor.constraint(equalToConstant: 40),
            timeIconView.heightAnchor.constraint(equalTo: timeIconView.widthAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UITableViewCell
    public override func setSelected(_ selected: Bool, animated: Bool) {
        return
    }

    // MARK: - Public Methods
    public func configure(with viewModel: TimeSettingViewModel) {
        self.viewModel = viewModel

        bindViewModel()
    }


    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.timeOptions
            .subscribe(onNext: { [weak self] updatedOptions in
                self?.timePicker.reloadAllComponents()
            }).disposed(by: bag)

        timePicker.selectRow(viewModel.selectedTimeIndex.value ?? 0, inComponent: 0, animated: false)
    }


    // MARK: - Constants
    public static let cellId = "TimeSettingTableViewCell"

}


// MARK: - UIPickerViewDataSource
extension TimeSettingTableViewCell: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.timeOptions.value.count
    }

}


// MARK: - UIPickerViewDelegate
extension TimeSettingTableViewCell: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.timeOptions.value[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedTimeIndex.accept(row)
    }

}
