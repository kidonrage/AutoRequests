//
//  SignedInViewController.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import Foundation
import RxSwift
import AutoRequestsUIKit
import AutoRequestsKit

public final class SignedInViewController: NiblessViewController {

    // MARK: - Private Properties
    // ViewModel
    private let viewModel: SignedInViewModel
    private let bag = DisposeBag()
    // Child View Controllers
    private var driverNavigationVC: DriverNavigationController?
    private var passengerNavigationVC: PassengerNavigationController?
    // Factories
    private let makeDriverNavigationVC: () -> DriverNavigationController
    private let makePassengerNavigationVC: () -> PassengerNavigationController

    // MARK: - Initializers
    public init(viewModel: SignedInViewModel,
                driverNavigationVCFactory: @escaping () -> DriverNavigationController,
                passengerNavigationVCFactory: @escaping () -> PassengerNavigationController) {
        self.viewModel = viewModel
        self.makeDriverNavigationVC = driverNavigationVCFactory
        self.makePassengerNavigationVC = passengerNavigationVCFactory

        super.init()
    }

    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    // MARK: - Private Methods
    private func present(_ view: SignedInView) {
        switch view {
        case .driver:
            startDriverFlow()
        case .passenger:
            startPassengerFlow()
        }
    }

    private func startDriverFlow() {
        let driverNavigationVC = makeDriverNavigationVC()
        self.driverNavigationVC = driverNavigationVC

        addFullScreen(childViewController: driverNavigationVC)
    }

    private func startPassengerFlow() {
        let passengerNavigationVC = makePassengerNavigationVC()
        self.passengerNavigationVC = passengerNavigationVC

        addFullScreen(childViewController: passengerNavigationVC)
    }

    private func bindViewModel() {
        viewModel.view.subscribe(onNext: { [weak self] view in
            self?.present(view)
        }).disposed(by: bag)
    }

}
