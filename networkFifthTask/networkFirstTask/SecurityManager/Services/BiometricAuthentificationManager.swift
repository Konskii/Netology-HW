//
//  BiometricAuthentificationManager.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 25.01.2021.
//  Copyright © 2021 Артём Скрипкин. All rights reserved.
//

import LocalAuthentication

class BiometricAuthentificationService {
    private let reason = "Авторизуйтесь, чтобы использовать сохраненные данные."
    
    public func authentificate(completion: @escaping (Result<Bool, Error>) -> Void) {
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    completion(.success(true))
                } else {
                    guard let error = error else { return }
                    completion(.failure(error))
                }
            }
        }
    }
}
