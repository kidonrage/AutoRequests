//
//  CreateRequestViewModel.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 10.06.2021.
//

import Foundation
import RxSwift

public final class CreateRequestViewModel: AddressSettingViewModelProtocol, CommentSettingViewModelProtocol {

    // MARK: - Public Properties
    public let dateSettingViewModel = DateSettingViewModel()
    public let driverSettingViewModel = DriverSettingViewModel()
    public let timeSettingViewModel = TimeSettingViewModel()

    public let selectedAddress = BehaviorSubject<String?>(value: nil)
    public let comment = BehaviorSubject<String?>(value: nil)

    public let isRequestAvailableToSave = BehaviorSubject<Bool>(value: false)

    // MARK: - Private Properties
    private let bag = DisposeBag()

    // MARK: - Initializers
    public init() {
        Observable.combineLatest(driverSettingViewModel.selectedDriver, driverSettingViewModel.selectedCar, selectedAddress)
            .map { $0 != nil && $1 != nil && !($2?.isEmpty ?? true) }
            .subscribe(onNext: { [weak self] in self?.isRequestAvailableToSave.onNext($0) })
            .disposed(by: bag)
    }

}
