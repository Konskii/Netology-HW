//
//  KeychainManager.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 25.01.2021.
//  Copyright © 2021 Артём Скрипкин. All rights reserved.
//

import Foundation

final class KeychainService {
    
    private let service = "GitAppService"
    
    private func createKeychainQuerry(account: String? = nil) -> [String: Any] {
        var querry: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccessible as String:  kSecAttrAccessibleWhenUnlocked,
            kSecAttrService as String: service
        ]
        if let account = account {
            querry[kSecAttrAccount as String] = account as AnyObject
        }
        return querry
    }
    
    func readCredentials() -> Credentials? {
        var querry = createKeychainQuerry()
        querry[kSecMatchLimit as String] = kSecMatchLimitOne
        querry[kSecReturnData as String] = true
        querry[kSecReturnAttributes as String] = true
        
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(querry as CFDictionary, &item)
        if status != noErr {
            return nil
        }
        
        guard let exsistingItem = item as? [String: AnyObject],
              let passwordData = exsistingItem[kSecValueData as String] as? Data,
              let account = exsistingItem[kSecAttrAccount as String] as? String,
              let password = String(data: passwordData, encoding: .utf8)
        else { return nil}
        
        return Credentials(username: account, password: password)
    }
    
     func saveToKeychain(account: String, password: String) -> Bool {
        let passwordData = password.data(using: .utf8)
        if readCredentials() != nil {
            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: passwordData as Any,
                kSecAttrAccount as String: account
            ]
            
            let query = createKeychainQuerry()
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        
        var item = createKeychainQuerry(account: account)
        item[kSecValueData as String] = passwordData as AnyObject
        
        let status = SecItemAdd(item as CFDictionary, nil)
        return status == noErr
    }
    
}
