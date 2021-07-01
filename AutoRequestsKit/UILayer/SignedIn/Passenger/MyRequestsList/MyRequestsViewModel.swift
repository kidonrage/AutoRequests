//
//  MyRequestsViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

public class UserTransportRequestsViewModel {

    // MARK: - Public Properties
    public let sections = BehaviorRelay<[SectionModel<String, TransportApplication>]>(value: [])

    public let isNetworkActivityInProgress = BehaviorRelay<Bool>(value: false)
    public let errorMessage = BehaviorRelay<String?>(value: nil)

    // MARK: - Private Properties
    internal let myRequests = BehaviorRelay<[TransportApplication]>(value: [])
    private let transportRequestsRepository: TransportRequestsRepository
    private let bag = DisposeBag()
    private let notSignedInResponder: NotSignedInResponder

    // MARK: - Initializers
    public init(transportRequestsRepository: TransportRequestsRepository,
                notSignedInResponder: NotSignedInResponder) {
        self.transportRequestsRepository = transportRequestsRepository
        self.notSignedInResponder = notSignedInResponder

        myRequests.subscribe(onNext: { [weak self] (updatedApplications) in
            self?.updateSections()
        }).disposed(by: bag)

    }

    // MARK: - Public Methods
    @objc
    public func logout() {
        notSignedInResponder.handleNotSignedIn()
    }

    public func getUserRequests() {
        isNetworkActivityInProgress.accept(true)

        transportRequestsRepository.getTransportRequestsForCurrentUser()
            .done { [weak self] (requests) in
                self?.myRequests.accept(requests)
            }
            .catch { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }
            .finally { [weak self] in
                self?.isNetworkActivityInProgress.accept(false)
            }
    }

    // MARK: - Private Methods
    private func updateSections() {
        var dict: [String: [TransportApplication]] = [:]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.locale = Locale(identifier: "ru-RU")

        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "dd.MM.yyyy"

        let today = Date().startOfDay

        myRequests.value.forEach { (application) in
            if application.date == dateFormatter.string(from: today) {
                var applicationsForToday = dict["Сегодня"] ?? []
                applicationsForToday.append(application)
                dict["Сегодня"] = applicationsForToday
            } else {
                let date = dateFormatter.date(from: application.date)!
                let dateStringToDisplay = dateFormatterDisplay.string(from: date)

                var applications = dict[dateStringToDisplay] ?? []
                applications.append(application)
                dict[dateStringToDisplay] = applications
            }
        }

        let updatedSections = dict
            .sorted(by: { (keyValueA, keyValueB) in
                if keyValueA.key == "Сегодня" {
                    return true
                } else if keyValueB.key == "Сегодня" {
                    return false
                }

                let dateA = dateFormatter.date(from: keyValueA.key)!
                let dateB = dateFormatter.date(from: keyValueB.key)!

                return dateA < dateB
            })
            .map { (dateString, applications) -> SectionModel<String, TransportApplication> in
            return SectionModel(model: dateString, items: applications)
        }

        sections.accept(updatedSections)
    }

}
