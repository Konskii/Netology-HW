//
//  LogInViewController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let login = loginTextField.text, !login.isEmpty else {
            deactivateButton()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            deactivateButton()
            return
        }
        print(login)
        print(password)
        activateButton()
    }
    
    private func activateButton() {
        signInButton.layer.opacity = 1
    }
    
    private func deactivateButton() {
        signInButton.layer.opacity = 0.3
    }
    
    @IBAction func signInTapped() {
        guard let login = loginTextField.text else { return }
        guard let password = passwordTextField.text else { return}
        let credentials = Credentials(login: login, password: password)
        NetworkManager().authorize(credentials: credentials) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error!", message: "\(error)")
                }
            case .success(let token):
                NetworkManager.setToken(token: token.token)
                DispatchQueue.main.async {
                    AppDelegate.shared.rootViewController.showMainTabBarScreen()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let toolBar = UIToolbar()
        let send = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(signInTapped))
        toolBar.items = [send]
        toolBar.sizeToFit()
        loginTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        deactivateButton()
        loginTextField.keyboardType = .emailAddress
        loginTextField.autocorrectionType = .no
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        setToolbarItems([.init(title: "Send", style: .done, target: self, action: #selector(signInTapped))], animated: true)
        loginTextField.text = "user"
        passwordTextField.text = "qwerty"
    }
}
