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

    public let isNetworkActivityInProgress = BehaviorRelay<Bool>(value: false)
    public let errorMessage = BehaviorRelay<String?>(value: nil)

    public let view = BehaviorRelay<CreateRequestView>(value: .createRequest)

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

        selectedDriver.subscribe(onNext: { [weak self] (selectedDriver) in
            self?.refreshSelectedDriverAvailableTimeRanges()
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

        isNetworkActivityInProgress.accept(true)


        autoRequestsRepository.saveTransportRequest(request: request)
            .done { [weak self] _ in
                self?.view.accept(.requestCreated)
                self?.selectedDate.accept(Date())
                self?.selectedDriver.accept(nil)
                self?.driverOptions.accept([])
                self?.selectedAddress.accept("")
                self?.comment.accept(nil)
            }
            .catch { [weak self] (error) in
                self?.errorMessage.accept(error.localizedDescription)
            }
            .finally { [weak self] in
                self?.isNetworkActivityInProgress.accept(false)
            }
    }

    public func handleSelectDriver(on indexPath: IndexPath) {
        let updatedSelectedDriver = driverOptions.value[indexPath.row]

        selectedDriver.accept(updatedSelectedDriver)
    }

    // MARK: - Private Methods
    private func refreshAvailableDrivers() {
        let formattedDateString = dateFormatter.string(from: selectedDate.value)

        isNetworkActivityInProgress.accept(true)

        driversRepository.getAvailableDrivers(dateString: formattedDateString)
            .done { [weak self] (availableDrivers) in
                self?.driverOptions.accept(availableDrivers)
                self?.selectedDriver.accept(nil)
            }
            .catch { [weak self] (error) in
                self?.errorMessage.accept(error.localizedDescription)
            }
            .finally { [weak self] in
                self?.isNetworkActivityInProgress.accept(false)
            }
    }

    private func refreshSelectedDriverAvailableTimeRanges() {
        guard let driverId = selectedDriver.value?.id else {
            timeSettingViewModel.timeOptions.accept([])
            return
        }

        let dateString = dateFormatter.string(from: selectedDate.value)

        isNetworkActivityInProgress.accept(true)

        driversRepository.getAvailableTimeRangesForDriver(withId: driverId, onDateString: dateString)
            .done { [weak self] (timeRanges) in
                self?.timeSettingViewModel.timeOptions.accept(timeRanges)
            }
            .catch { [weak self] (error) in
                self?.errorMessage.accept(error.localizedDescription)
            }
            .finally { [weak self] in
                self?.isNetworkActivityInProgress.accept(false)
            }
    }

}
