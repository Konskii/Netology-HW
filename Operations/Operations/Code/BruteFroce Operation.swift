//
//  BruteFroce Operation.swift
//  Operations
//
//  Created by Артём Скрипкин on 18.09.2020.
//

import Foundation
class BruteForceOperation: Operation {
    
    private let inputPassword: String
    private let maxIndex = Consts.characterArray.count
    private let characterArray = Consts.characterArray
    
    private(set) var foundPass: String?
    private var startIndexArray = [Int]()
    private var endIndexArray = [Int]()
    private var startString = ""
    private var endString = ""
    
    required init(startIndex: Int, endIndex: Int, password: String) {
        for _ in 0..<Consts.maxTextFieldTextLength {
            self.startString += characterArray[startIndex]
            self.endString += characterArray[endIndex]
        }
        self.inputPassword = password
    }
    
    override func main() {
        //Перед запуском проверяем завершена ли операция
//        if isCancelled {
//            return
//        }
        // Создает массивы индексов из входных строк
        for char in startString {
            for (index, value) in characterArray.enumerated() where value == "\(char)" {
                startIndexArray.append(index)
            }
        }
        for char in endString {
            for (index, value) in characterArray.enumerated() where value == "\(char)" {
                endIndexArray.append(index)
            }
        }
        
        var currentIndexArray = startIndexArray
        
        while true {
            var currentPass = ""
            
            // Формируем строку проверки пароля из элементов массива символов
            for i in 0..<Consts.maxTextFieldTextLength {
                currentPass += characterArray[currentIndexArray[i]]
            }
            
            // Выходим из цикла если пароль найден
            if inputPassword == currentPass {
                foundPass = currentPass
                break
            } else {
                //Если пароль не найден, то проверяем не дошли ли мы до конца индексов
                if currentIndexArray.elementsEqual(endIndexArray) {
                    break
                }
                //Если все ок, то прибавляем +1 к индексу, а если индекс максимальный,
                //то увеличиваем следующий после него на 1, а сам индекс приравниваем к нулю
                for index in (0 ..< currentIndexArray.count).reversed() {
                    guard currentIndexArray[index] < maxIndex - 1 else {
                        currentIndexArray[index] = 0
                        continue
                    }
                    currentIndexArray[index] += 1
                    break
                }
            }
        }
    }
}
