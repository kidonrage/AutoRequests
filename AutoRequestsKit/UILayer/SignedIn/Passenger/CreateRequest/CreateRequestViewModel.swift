//
//  CreateRequestViewModel.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 10.06.2021.
//

import Foundation
import RxSwift
import RxRelay

public final class CreateRequestViewModel: DriverSettingViewModelProtocol, DateSettingViewModelProtocol, AddressSettingViewModelProtocol, CommentSettingViewModelProtocol {

    // MARK: - Public Properties
    public let timeSettingViewModel = TimeSettingViewModel()

    public let selectedDate = BehaviorRelay<Date>(value: Date())
    public var selectedDriver = BehaviorRelay<Driver?>(value: nil)
    public var driverOptions = BehaviorRelay<[Driver]>(value: [])
    public let selectedAddress = BehaviorRelay<String>(value: "")
    public let comment = BehaviorRelay<String?>(value: nil)

    public let isRequestAvailableToSave = BehaviorSubject<Bool>(value: false)

    // MARK: - Private Properties
    private let userSession: UserSession
    private let driversRepository: DriversRepository
    private let autoRequestsRepository: TransportRequestsRepository
    private let bag = DisposeBag()
    private let dateFormatter: DateFormatter

    // MARK: - Initializers
    public init(userSession: UserSession, driversRepository: DriversRepository, autoRequestsRepository: TransportRequestsRepository) {
        self.userSession = userSession
        self.driversRepository = driversRepository
        self.autoRequestsRepository = autoRequestsRepository

        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"

        selectedDate.subscribe(onNext: { [weak self] (selectedDate) in
            self?.refreshAvailableDrivers()
        }).disposed(by: bag)

        Observable.combineLatest(selectedDriver, selectedAddress)
            .map { $0 != nil && !($1.isEmpty) }
            .subscribe(onNext: { [weak self] in self?.isRequestAvailableToSave.onNext($0) })
            .disposed(by: bag)
    }

    // MARK: - Public Methods
    @objc
    public func saveTransportRequest() {
        guard let driverId = selectedDriver.value?.id else {
            return
        }

        let date = selectedDate.value
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

    public func handleSelectDriver(on indexPath: IndexPath) {

    }

    // MARK: - Private Methods
    private func refreshAvailableDrivers() {
        let formattedDateString = dateFormatter.string(from: selectedDate.value)

        driversRepository.getAvailableDrivers(dateString: formattedDateString)
            .done { [weak self] (availableDrivers) in
                self?.driverOptions.accept(availableDrivers)
            }
            .catch { (error) in
                print(error.localizedDescription)
            }
    }

}
