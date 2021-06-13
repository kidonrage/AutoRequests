//
//  CreateRequestViewModel.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 10.06.2021.
//

import Foundation
import RxSwift

public final class CreateRequestViewModel {

    // MARK: - Public Properties
    public let dateSettingViewModel = DateSettingViewModel()
    public let timeSettingViewModel = TimeSettingViewModel()
    public let driverSettingViewModel = DriverSettingViewModel()
    public let isRequestAvailableToSave = BehaviorSubject<Bool>(value: false)

    // MARK: - Private Properties
    private let bag = DisposeBag()

    // MARK: - Initializers
    public init() {
        Observable.combineLatest(driverSettingViewModel.selectedDriver, driverSettingViewModel.selectedCar)
            .map { $0 != nil && $1 != nil }
            .subscribe(onNext: { [weak self] in self?.isRequestAvailableToSave.onNext($0) })
            .disposed(by: bag)
    }

}
