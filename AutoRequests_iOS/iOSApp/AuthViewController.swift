//
//  AuthViewController.swift
//  AutoRequests
//
//  Created by Vlad Eliseev on 23.05.2021.
//

import UIKit
import AutoRequestsUIKit

class AuthViewController: UIViewController {

    @IBOutlet var loginField: UITextField!
    @IBOutlet var passwordField: UITextField!

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Private Methods
    @IBAction private func logInButtonTapped(_ sender: Any) {
        guard
            let login = loginField.text, !login.isEmpty,
            let password = passwordField.text, !password.isEmpty
        else {
            return
        }

        let isDriver = login == "driver" && password == "driver"
        let isPassenger = login == "passenger" && password == "passenger"

        if isPassenger {
            performSegue(withIdentifier: "fromAuthToPassenger", sender: self)
        } else if isDriver {
            performSegue(withIdentifier: "fromAuthToDriver", sender: self)
        } else {
            displayCredentialsErrorMessage()
        }
    }

    private func displayCredentialsErrorMessage() {
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)

        display(title: "Ошибка авторизации", message: "Не найден пользователь с такой парой логин/пароль", actions: [okAction])
    }

}


// MARK: - AlertDisplayer
extension AuthViewController: AlertDisplayer {}
