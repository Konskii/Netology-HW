//
//  BruteFroce Operation.swift
//  Operations
//
//  Created by Артём Скрипкин on 18.09.2020.
//

import Foundation
class BruteForceOperation: Operation {
    ///Пароль, с котороым будет сравниваться результат брутфорса.
    private var password: String
    ///Найденный пароль
    var foundPass: String?
    var startIndex: [Int]
    var endIndex: [Int]
    let maxIndex = Int()
    var currentIndex: [Int]
    
    ///Массив знаков
    let characters = Consts.characterArray
    
    required init(currentPassword: String, startIndex: [Int], endIndex: [Int]) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.password = currentPassword
        self.currentIndex = startIndex
    }
    
    
    override func main() {
        if isCancelled {
            return
        }
        
        while true {
            ///Генерируемый пароль
            let pass = characters[startIndex[0]] + characters[startIndex[1]] + characters[startIndex[2]] + characters[startIndex[3]]
            
            ///Проверка на то, сходится ли пароль
            if password == pass {
                foundPass = pass
            } else {
                ///Если пароль не сходится, то проверяем не дошли ли мы до конца индексов
                if currentIndex.elementsEqual(endIndex) {
                    cancel()
                    break
                }
                
                ///Если все ок, то увеличваем индекс, с конца. Если индекс который мы хотим увеличить равен maxIndex, то увеличиваем слева стоящий от него, а его самого возвращаем к startIndex[3]
                for index in (0 ..< currentIndex.count).reversed() {
                    guard currentIndex[index] < maxIndex - 1 else {
                        currentIndex[index] = 0
                        continue
                    }
                    currentIndex[index] += 1
                    break
                }
            }
        }
    }
}
