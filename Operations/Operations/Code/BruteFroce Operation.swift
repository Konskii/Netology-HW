//
//  BruteFroce Operation.swift
//  Operations
//
//  Created by Артём Скрипкин on 18.09.2020.
//

import Foundation
class BruteForceOperation: Operation {
    ///Пароль, с котороым будет сравниваться результат брутфорса.
    let inputPassword: String
    var startIndexArray = [Int]()
    
    var endIndexArray = [Int]()
    let maxIndexArray: Int
    
    ///Массив знаков
    let characterArray: [String]
    
    required init(inputPassword: String, characterArray: [String]) {
        self.inputPassword = inputPassword
        self.maxIndexArray = characterArray.count
        self.characterArray = characterArray
    }
}
