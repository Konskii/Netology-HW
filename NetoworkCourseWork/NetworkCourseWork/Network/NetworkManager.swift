//
//  NetworkManager.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import Foundation
extension String: Error {}

class NetworkManager{
    
    var token = ""
    
    private let scheme = "http"
    private let host = "localhost"
    private let port = 8080
    
    enum httpMethods: String {
        case GET
        case POST
    }
    
    private func getUrl(forPath path: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.port = port
        urlComponents.path = path
        return urlComponents.url
    }
    
    private func getRequest(withURL url: URL, method: httpMethods) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if !token.isEmpty {
            request.addValue(token, forHTTPHeaderField: "token")
        }
        return request
    }
    
    private func dataTask<T: Codable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { completion(.failure(error)) }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else {
                completion(.failure(ErrorHandler().handleError(withHttpCode: response.statusCode)))
                return
            }
            guard let data = data else { completion(.failure(ErrorHandler().handleError())); return }
            guard let parsedData = try? JSONDecoder().decode(T.self, from: data) else {completion(.failure(ErrorHandler().handleError())); return }
            completion(.success(parsedData))
        }.resume()
    }
    
    public func authorize(credentials: Credentials,
                          completion: @escaping (Result<Token, Error>) -> Void) {
        guard let url = getUrl(forPath: AuthentificationPaths.signin) else { return }
        guard var request = getRequest(withURL: url, method: .POST) else { return }
        guard let body = try? JSONEncoder().encode(credentials) else { return }
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = body
        dataTask(request: request, completion: completion)
    }
}
