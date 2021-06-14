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
        field.autocapitalizationType = .none

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
    private lazy var formStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fieldsView, signInButton])

        stackView.axis = .vertical
        stackView.spacing = 16

        return stackView
    }()
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), formStack, UIView()])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.distribution = .equalCentering

        return stackView
    }()
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Private Methods
    private func displayCredentialsErrorMessage() {
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)

        display(title: "Ошибка авторизации", message: "Не найден пользователь с такой парой логин/пароль", actions: [okAction])
    }

    @objc private func handleKeyboardShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo as NSDictionary?,
            let keyboardSize = (userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?
            .cgRectValue.size
        else {
            return
        }

        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)

        setScrollViewInsets(contentInset)
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero

        setScrollViewInsets(contentInset)
    }

    @objc private func dismissKeyboard() {
        contentScrollView.endEditing(true)
    }

    private func setScrollViewInsets(_ insets: UIEdgeInsets) {
        contentScrollView.contentInset = insets
        contentScrollView.scrollIndicatorInsets = insets
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(contentScrollView)

        contentScrollView.addSubview(contentStack)

        fieldsView.addSubview(fieldsStack)

        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            contentStack.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),

            fieldsStack.topAnchor.constraint(equalTo: fieldsView.topAnchor),
            fieldsStack.leadingAnchor.constraint(equalTo: fieldsView.leadingAnchor, constant: 8),
            fieldsStack.trailingAnchor.constraint(equalTo: fieldsView.trailingAnchor, constant: -8),
            fieldsStack.bottomAnchor.constraint(equalTo: fieldsView.bottomAnchor),

            loginField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.heightAnchor.constraint(equalToConstant: 40),

            signInButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        contentScrollView.addGestureRecognizer(dismissKeyboardGesture)
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
