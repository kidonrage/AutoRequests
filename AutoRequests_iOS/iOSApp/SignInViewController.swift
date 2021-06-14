//
//  SignInViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 23.05.2021.
//

import UIKit
import RxSwift
import AutoRequestsUIKit
import AutoRequestsKit

public class SignInViewController: UIViewController {

    // MARK: - VisualComponents
    private let loginField: UITextField = {
        let field = UITextField()

        field.placeholder = "Логин"

        return field
    }()
    private let passwordField: UITextField = {
        let field = UITextField()

        field.placeholder = "Пароль"
        field.isSecureTextEntry = true

        return field
    }()
    private lazy var fieldsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginField, passwordField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var fieldsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fieldsView, signInButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 16

        return stackView
    }()


    // MARK: - Private Properties
    private let viewModel: SignInViewModel
    private let bag = DisposeBag()

    // MARK: - Initializers
    public init(viewModel: SignInViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    // MARK: - Private Methods
//    @IBAction private func logInButtonTapped(_ sender: Any) {
//        guard
//            let login = loginField.text, !login.isEmpty,
//            let password = passwordField.text, !password.isEmpty
//        else {
//            return
//        }
//
//        let isDriver = login == "driver" && password == "driver"
//        let isPassenger = login == "passenger" && password == "passenger"
//
//        if isPassenger {
//            performSegue(withIdentifier: "fromAuthToPassenger", sender: self)
//        } else if isDriver {
//            performSegue(withIdentifier: "fromAuthToDriver", sender: self)
//        } else {
//            displayCredentialsErrorMessage()
//        }
//    }

    private func displayCredentialsErrorMessage() {
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)

        display(title: "Ошибка авторизации", message: "Не найден пользователь с такой парой логин/пароль", actions: [okAction])
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(contentStack)

        fieldsView.addSubview(fieldsStack)

        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            fieldsStack.topAnchor.constraint(equalTo: fieldsView.topAnchor),
            fieldsStack.leadingAnchor.constraint(equalTo: fieldsView.leadingAnchor, constant: 8),
            fieldsStack.trailingAnchor.constraint(equalTo: fieldsView.trailingAnchor, constant: -8),
            fieldsStack.bottomAnchor.constraint(equalTo: fieldsView.bottomAnchor),

            loginField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.heightAnchor.constraint(equalToConstant: 40),

            signInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func bindViewModel() {
        signInButton.addTarget(viewModel, action: #selector(SignInViewModel.signIn), for: .touchUpInside)

        loginField.rx.text.compactMap({ return $0 })
            .bind(to: viewModel.login)
            .disposed(by: bag)
        viewModel.login
            .bind(to: loginField.rx.text)
            .disposed(by: bag)

        passwordField.rx.text.compactMap({ return $0 })
            .bind(to: viewModel.password)
            .disposed(by: bag)
        viewModel.password
            .bind(to: passwordField.rx.text)
            .disposed(by: bag)

        viewModel.isSignInButtonEnabled
            .subscribe(onNext: { [weak self] isEnabled in
                self?.signInButton.rx.isEnabled.onNext(isEnabled)
                self?.signInButton.rx.backgroundColor.onNext(isEnabled ? .systemBlue : .systemGray)
            })
            .disposed(by: bag)
    }

}


// MARK: - AlertDisplayer
extension SignInViewController: AlertDisplayer {}
