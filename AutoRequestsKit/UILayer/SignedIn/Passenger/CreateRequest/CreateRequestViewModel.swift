//
//  CreateRequestViewModel.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 10.06.2021.
//

import Foundation
import RxSwift
import RxRelay

public final class CreateRequestViewModel: AddressSettingViewModelProtocol, CommentSettingViewModelProtocol {

    // MARK: - Public Properties
    public let dateSettingViewModel = DateSettingViewModel()
    public let driverSettingViewModel = DriverSettingViewModel()
    public let timeSettingViewModel = TimeSettingViewModel()

    public let selectedAddress = BehaviorRelay<String>(value: "")
    public let comment = BehaviorRelay<String?>(value: nil)

    public let isRequestAvailableToSave = BehaviorSubject<Bool>(value: false)

    // MARK: - Private Properties
    private let userSession: UserSession
    private let autoRequestsRepository: TransportRequestsRepository
    private let bag = DisposeBag()

    // MARK: - Initializers
    public init(userSession: UserSession, autoRequestsRepository: TransportRequestsRepository) {
        self.userSession = userSession
        self.autoRequestsRepository = autoRequestsRepository

        Observable.combineLatest(driverSettingViewModel.selectedDriver, selectedAddress)
            .map { $0 != nil && !($1.isEmpty) }
            .subscribe(onNext: { [weak self] in self?.isRequestAvailableToSave.onNext($0) })
            .disposed(by: bag)
    }

    // MARK: - Public Methods
    @objc
    public func saveTransportRequest() {
        guard let driverId = driverSettingViewModel.selectedDriver.value?.id else {
            return
        }

        let date = dateSettingViewModel.selectedDate.value

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        let dateString = dateFormatter.string(from: date)

        let request = TransportApplicationRequest(passengerId: userSession.profile.id,
                                                  driverId: driverId,
                                                  address: selectedAddress.value,
                                                  date: dateString,
                                                  timeRange: timeSettingViewModel.timeOptions.value[timeSettingViewModel.selectedTimeIndex.value ?? 0],
                                                  comment: comment.value)


        autoRequestsRepository.saveTransportRequest(request: request)
            .done { _ in
                print("ok")
            }
            .catch { (error) in
                print("not ok \(error.localizedDescription)")
            }
    }

}
