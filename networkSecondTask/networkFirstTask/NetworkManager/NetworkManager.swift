//
//  NetworkManager.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 01.11.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import Foundation
class NetworkManager {
    private let scheme = "https"
    private let host = "api.github.com"
    private let searchRepoPath = "/search/repositories"
    private let defaultHeaders = [
        "Content-Type" : "application/json",
        "Accept" : "application/vnd.github.v3+json"
    ]
    
    private let sharedSession = URLSession.shared
    
    private func createSearchRequest(repoName: String, language: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = scheme
        urlComponents.path = searchRepoPath
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(repoName)+language:\(language)"),
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        return request
    }
    
    public func search(repoName: String, language: String) {
        guard let request = createSearchRequest(repoName: repoName, language: language) else { return }
        let task = sharedSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("http status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            guard let text = String(data: data, encoding: .utf8) else {
                print("data encoding failed")
                return
            }
            print("received data: \(text)")
        }
        task.resume()
    }
}
