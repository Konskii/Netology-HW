//
//  ErrorHandler.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import Foundation
class ErrorHandler {
    func handleError(withHttpCode code: Int? = nil) -> String {
        guard let code = code else { return "Unknown error" }
        switch code {
        case 400: return "Bad request"
        case 401: return "Unauthorized"
        case 404: return "Not Found"
        case 406: return "Not acceptable"
        case 422: return "Unprocessable"
        default: return "Transfer error"
        }
    }
}
