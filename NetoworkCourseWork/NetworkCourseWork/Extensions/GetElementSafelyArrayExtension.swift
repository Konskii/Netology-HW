//
//  GetElementSafelyArrayExtension.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 29.01.2021.
//

import Foundation

extension Array {
    func getElement(at index: Int) -> Element? {
        guard index < count else { return nil }
        return self[index]
    }
}
