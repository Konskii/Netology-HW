//
//  SecurityManager.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 25.01.2021.
//  Copyright © 2021 Артём Скрипкин. All rights reserved.
//

import Foundation
final class SecurityManager {
    private let biometry = BiometricAuthentificationService()
    private let keychain = KeychainService()
    
    public func authentificateUser(completion: @escaping (Credentials?) -> Void) {
        if let credentials = keychain.readCredentials() {
            biometry.authentificate() { result in
                switch result {
                case .success(let status):
                    guard status else { return }
                    completion(credentials)
                case .failure(_):
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    public func savePassword(account: String, password: String) -> Bool {
        keychain.saveToKeychain(account: account, password: password)
    }
}
