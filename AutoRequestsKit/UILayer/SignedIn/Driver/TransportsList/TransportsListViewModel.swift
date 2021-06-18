//
//  TransportsListViewModel.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 18.06.2021.
//

import Foundation
import RxRelay
import RxSwift

public final class TransportsListViewModel: UserTransportRequestsViewModel {

    public let selectedRequestIndexPath = BehaviorRelay<IndexPath?>(value: nil)
    public let presentedView = BehaviorRelay<DriverView>(value: .transportsList)

    private let bag = DisposeBag()

    public override init(transportRequestsRepository: TransportRequestsRepository) {
        super.init(transportRequestsRepository: transportRequestsRepository)

        selectedRequestIndexPath
            .map { [weak self] (indexPath) -> TransportRequest? in
                guard let index = indexPath?.row else {
                    return nil
                }

                return self?.myRequests.value[index]
            }
            .subscribe(onNext: { [weak self] (selectedRequest) in
                guard let selectedRequest = selectedRequest else {
                    return
                }

                self?.presentedView.accept(.requestDetails(request: selectedRequest))
            })
            .disposed(by: bag)
    }

}
