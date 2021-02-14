//
//  LogInViewController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Init
    //MARK: - Properties
    //MARK: - UI Outlets
    //MARK: - UI Elemetns
    //MARK: - Public methods
    //MARK: - Private methods
    //MARK: - Private objc methods
    //MARK: - Life cycle
    
    
    //MARK: - UI Outlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: - Public methods
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let login = loginTextField.text, !login.isEmpty else {
            deactivateButton()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            deactivateButton()
            return
        }
        activateButton()
    }
    
    //MARK: - Private methods
    private func activateButton() {
        signInButton.layer.opacity = 1
    }
    
    private func deactivateButton() {
        signInButton.layer.opacity = 0.3
    }
    
    private func configureKeyboardToolBar() {
        let toolBar = UIToolbar()
        let send = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(signInTapped))
        toolBar.items = [send]
        toolBar.sizeToFit()
        loginTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        setToolbarItems([.init(title: "Send", style: .done, target: self, action: #selector(signInTapped))], animated: true)
    }
    
    //MARK: - Private objc methods
    @IBAction private func signInTapped() {
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
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboardToolBar()
        deactivateButton()
    }
}
