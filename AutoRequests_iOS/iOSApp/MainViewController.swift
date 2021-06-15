//
//  MainViewController.swift
//  AutoRequests_iOS
//
//  Created by Vlad Eliseev on 15.06.2021.
//

import UIKit
import RxSwift
import AutoRequestsUIKit
import AutoRequestsKit

public final class MainViewController: NiblessViewController {

    // MARK: - Private Properties
    // View Model
    private let viewModel: MainViewModel
    private let bag = DisposeBag()
    // Child View Controllers
    private let launchViewController: LaunchViewController
    private var signInViewController: SignInViewController?
    private var signedInViewController: SignedInViewController?
    // Factories
    private let makeSignInViewController: () -> SignInViewController
    private let makeSignedInViewController: (UserSession) -> SignedInViewController

    // MARK: - Initializers
    public init(viewModel: MainViewModel,
                launchViewController: LaunchViewController,
                signInViewControllerFactory: @escaping () -> SignInViewController,
                signedInViewControllerFactory: @escaping (UserSession) -> SignedInViewController) {
        self.viewModel = viewModel
        self.launchViewController = launchViewController
        self.makeSignInViewController = signInViewControllerFactory
        self.makeSignedInViewController = signedInViewControllerFactory

        super.init()
    }

    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    // MARK: - Private Methods
    private func presentLaunching() {
        addFullScreen(childViewController: launchViewController)
    }

    private func presentSignIn() {
        let signInViewController = makeSignInViewController()
        signInViewController.modalPresentationStyle = .fullScreen
        present(signInViewController, animated: true) { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.remove(childViewController: strongSelf.launchViewController)
            if let signedInViewController = strongSelf.signedInViewController {
                strongSelf.remove(childViewController: signedInViewController)
                strongSelf.signedInViewController = nil
            }
        }
        self.signInViewController = signInViewController
    }

    private func presentSignedIn(userSession: UserSession) {
        remove(childViewController: launchViewController)

        let signedInViewControllerToPresent: SignedInViewController
        if let vc = self.signedInViewController {
            signedInViewControllerToPresent = vc
        } else {
            signedInViewControllerToPresent = makeSignedInViewController(userSession)
            self.signedInViewController = signedInViewControllerToPresent
        }

        addFullScreen(childViewController: signedInViewControllerToPresent)

        if signInViewController?.presentingViewController != nil {
            signInViewController = nil
            dismiss(animated: true)
        }
    }

    private func bindViewModel() {
        viewModel.view.subscribe(onNext: { [weak self] view in
            self?.present(view)
        }).disposed(by: bag)
    }

    private func present(_ view: MainView) {
        switch view {
        case .launching:
            presentLaunching()
        case .signIn:
            if signedInViewController?.presentingViewController == nil {
                if presentedViewController != nil {
                    // Дисмиссим когда совершаем выход.
                    dismiss(animated: true) { [weak self] in
                        self?.presentSignIn()
                    }
                } else {
                    presentSignIn()
                }
            }
        case .signedIn(let userSession):
            presentSignedIn(userSession: userSession)
        }
    }

}
