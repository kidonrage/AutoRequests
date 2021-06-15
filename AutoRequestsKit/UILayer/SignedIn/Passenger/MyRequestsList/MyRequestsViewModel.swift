//
//  MyRequestsViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 13.06.2021.
//

import Foundation
import RxRelay

public final class UserTransportRequestsViewModel {

    // MARK: - Public Properties
    public let myRequests = BehaviorRelay<[TransportRequest]>(value: [])
    public let isNetworkActivityInProgress = BehaviorRelay<Bool>(value: false)
    public let errorMessage = BehaviorRelay<String?>(value: nil)

    // MARK: - Private Properties
    private let transportRequestsRepository: TransportRequestsRepository

    // MARK: - Initializers
    public init(transportRequestsRepository: TransportRequestsRepository) {
        self.transportRequestsRepository = transportRequestsRepository
    }

    // MARK: - Private Methods
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

}
