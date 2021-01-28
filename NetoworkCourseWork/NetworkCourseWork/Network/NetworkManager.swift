//
//  NetworkManager.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import Foundation
extension String: Error {}
typealias Posts = [Post]
class NetworkManager{
    
    private static var token = ""
    
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
    
    private func getRequest(withURL url: URL, method: httpMethods, body: Data? = nil) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if !NetworkManager.token.isEmpty {
            request.addValue(NetworkManager.token, forHTTPHeaderField: "token")
        }
        if let body = body {
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.httpBody = body
        }
        return request
    }
    
    private func dataTask<T: Codable>(request: URLRequest,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { completion(.failure(error)) }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else {
                completion(.failure(ErrorHandler().handleError(withHttpCode: response.statusCode)))
                return
            }
            guard let data = data else { completion(.failure(ErrorHandler().handleError())); print(1); return }
            guard let parsedData = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(ErrorHandler().handleError()))
                return
            }
            completion(.success(parsedData))
        }.resume()
    }
    
    static func setToken(token: String) {
        self.token = token
    }
    
    static func deleteToken() {
        self.token = ""
    }
    
    public func authorize(credentials: Credentials,
                          completion: @escaping (Result<Token, Error>) -> Void) {
        guard let url = getUrl(forPath: AuthentificationPaths.signin) else { return }
        guard let body = try? JSONEncoder().encode(credentials) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }

    public func deauthorize(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = getUrl(forPath: AuthentificationPaths.signout) else { return }
        guard let request = getRequest(withURL: url, method: .POST) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func user(userId: String? = nil,
                                completion: @escaping (Result<User, Error>) -> Void) {
        if let userId = userId {
            guard let url = getUrl(forPath: UsersPaths.users + "/\(userId)") else { return }
            guard let request = getRequest(withURL: url, method: .GET) else { return }
            dataTask(request: request, completion: completion)
        } else {
            guard let url = getUrl(forPath: UsersPaths.currnetUser) else { return }
            guard let request = getRequest(withURL: url, method: .GET) else { return }
            dataTask(request: request, completion: completion)
        }
    }
    
    public func followTo(userIdToFollow id: String,
                         completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.follow) else { return }
        guard let body = try? JSONEncoder().encode(UserId(userID: id)) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func unfollowTo(userIdTounFollow id: String,
                           completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.unfollow) else { return }
        guard let body = try? JSONEncoder().encode(UserId(userID: id)) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func followers(userId: String,
                          completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.users + "/\(userId)" + UsersPaths.followers) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func following(userId: String,
                          completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.users + "/\(userId)" + UsersPaths.following) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func posts(userId: String,
                      completion: @escaping (Result<Posts, Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.users + "/\(userId)" + UsersPaths.posts) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func feed(completion: @escaping (Result<Posts, Error>) -> Void) {
        guard let url = getUrl(forPath: PostsPaths.feed) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func post(postId id: String,
                     completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = getUrl(forPath: PostsPaths.post + "/\(id)") else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func like(postIdToLike id: String,
                     completion: @escaping (Result<Post, Error>) -> Void ) {
        guard let url = getUrl(forPath: PostsPaths.like) else { return }
        guard let body = try? JSONEncoder().encode(PostId(postID: id)) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func unlike(postIdToUnlike id: String,
                       completion: @escaping (Result<Post, Error>) -> Void ) {
        guard let url = getUrl(forPath: PostsPaths.unlike) else { return }
        guard let body = try? JSONEncoder().encode(PostId(postID: id)) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func likes(postId id: String,
                      completion: @escaping (Result<[User], Error>) -> Void ) {
        guard let url = getUrl(forPath: PostsPaths.post + "/\(id)" + PostsPaths.likes) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    public func createPost(image: String, description: String,
                           completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = getUrl(forPath: PostsPaths.create) else { return }
        let post = PostCreate(image: image, description: description)
        guard let body = try? JSONEncoder().encode(post) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
}
