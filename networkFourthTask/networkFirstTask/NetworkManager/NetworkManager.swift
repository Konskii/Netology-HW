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
    private let userPath = "user"
    private let apiUrl = "https://api.github.com/"
    private let defaultHeaders = [
        "Content-Type" : "application/json",
        "Accept" : "application/vnd.github.v3+json"
    ]
    
    private enum SearchErrors: Error {
        case noData
        case decoding
        case badResponseCode(Int)
    }
    
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
        print(url)
        
        return request
    }
    
    public func search(repoName: String, language: String, completion: @escaping(Result<GitSearchResponse, Error>) -> Void) {
        guard let request = createSearchRequest(repoName: repoName, language: language) else { return }
        sharedSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    guard httpResponse.statusCode == 200 else { completion(.failure(SearchErrors.badResponseCode(httpResponse.statusCode))); return }
                    
                    guard let data = data else { completion(.failure(SearchErrors.noData)); return }
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(GitSearchResponse.self, from: data) else { completion(.failure(SearchErrors.decoding)); return }
                    completion(.success(decoded))
                }
            }
        }.resume()
    }
    
    private func createGetUserRequest(token: String) -> URLRequest? {
        guard var url = URL(string: apiUrl) else { return nil }
        url.appendPathComponent(userPath)
        var request = URLRequest(url: url)
        var headers = defaultHeaders
        headers["Authorization"] = "token \(token)"
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        return request
    }
    
    public func getUser(token: String, completion: @escaping (Result<Owner, Error>) -> Void ) {
        guard let request = createGetUserRequest(token: token) else { return }
        sharedSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    guard httpResponse.statusCode == 200 else { completion(.failure(SearchErrors.badResponseCode(httpResponse.statusCode))); return }
                    guard let data = data else { completion(.failure(SearchErrors.noData)); return }
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(Owner.self, from: data) else { completion(.failure(SearchErrors.decoding)); return }
                    completion(.success(decoded))
                }
            }
        }.resume()
    }
}
