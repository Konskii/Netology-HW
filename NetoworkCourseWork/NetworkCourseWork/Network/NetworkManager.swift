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
    
    /// - Parameter forPath: путь по которму нужно создать url
    private func getUrl(forPath path: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.port = port
        urlComponents.path = path
        return urlComponents.url
    }
    
    /// - Parameter withURL: url для создания request
    /// - Parameter method: тип запроса
    /// - Parameter body: тело запроса
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
    
    /// - Parameter request: request для dataTask
    /// - Parameter completion: замыкание, в которое передается в случае удачи указаный дженерик и ошибка в случае неудачи
    private func dataTask<T: Codable>(request: URLRequest,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { completion(.failure(ErrorHandler().handleError())); print(1) }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else {
                completion(.failure(ErrorHandler().handleError(withHttpCode: response.statusCode)))
                return
            }
            guard let data = data else { completion(.failure(ErrorHandler().handleError())); return }
            guard let parsedData = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(ErrorHandler().handleError()))
                print(3)
                return
            }
            completion(.success(parsedData))
        }.resume()
    }
    
    /// - Parameter token: - токен доступа
    static func setToken(token: String) {
        self.token = token
    }
    
    static func deleteToken() {
        self.token = ""
    }
    
    /// - Parameter credentials: username и password пользователя
    /// - Parameter completion: замыкание, в которое передается в случае удачи токен доступа и ошибка в случае неудачи
    /// - в случае успеха добавьте полученный токен с помощью NetworkManager.setToken(token: String)
    public func authorize(credentials: Credentials,
                          completion: @escaping (Result<Token, Error>) -> Void) {
        guard let url = getUrl(forPath: AuthentificationPaths.signin) else { return }
        guard let body = try? JSONEncoder().encode(credentials) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter userId: id user'a которого нужно получить. Если нужно получить текущего пользователя, то значение userId можно не указывать
    /// - Parameter completion: замыкание, в которое передается в случае удачи запрошенный user и ошибка в случае неудачи
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
    
    /// - Parameter userIdToFollow: id user'a на которого нужно подписаться
    /// - Parameter completion: замыкание, в которое передается в случае удачи обноленный user который подписался и ошибка в случае неудачи
    public func followTo(userIdToFollow id: String,
                         completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.follow) else { return }
        guard let body = try? JSONEncoder().encode(UserId(userID: id)) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter userIdToFollow: id user'a от которого нужно отписаться
    /// - Parameter completion: замыкание, в которое передается в случае удачи обноленный user который отписался и ошибка в случае неудачи
    public func unfollowTo(userIdTounFollow id: String,
                           completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.unfollow) else { return }
        guard let body = try? JSONEncoder().encode(UserId(userID: id)) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter userId: id user'а подписчиков которого нужно получить
    /// - Parameter completion: замыкание, в которое передается в случае удачи массив с подписчиками и ошибка в случае неудачи
    public func followers(userId: String,
                          completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.users + "/\(userId)" + UsersPaths.followers) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter userId: id user'а подписки которого нужно получить
    /// - Parameter completion: замыкание, в которое передается в случае удачи массив с подписками и ошибка в случае неудачи
    public func following(userId: String,
                          completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.users + "/\(userId)" + UsersPaths.following) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter userId: id user'а посты которого нужно получить
    /// - Parameter completion: замыкание, в которое передается в случае удачи массив с постами и ошибка в случае неудачи
    public func posts(userId: String,
                      completion: @escaping (Result<Posts, Error>) -> Void) {
        guard let url = getUrl(forPath: UsersPaths.users + "/\(userId)" + UsersPaths.posts) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter completion: замыкание, в которое передается в случае удачи массив с постами ленты и ошибка в случае неудачи
    public func feed(completion: @escaping (Result<Posts, Error>) -> Void) {
        guard let url = getUrl(forPath: PostsPaths.feed) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter postId: id post'а который нужно получить
    /// - Parameter completion: замыкание, в которое передается в случае удачи запрошенный пост и ошибка в случае неудачи
    public func post(postId id: String,
                     completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = getUrl(forPath: PostsPaths.post + "/\(id)") else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter postIdToLike: id post'а  который нужно лайкнуть
    /// - Parameter completion: замыкание, в которое передается в случае удачи лайкнутый пост и ошибка в случае неудачи
    public func like(postIdToLike id: String,
                     completion: @escaping (Result<Post, Error>) -> Void ) {
        guard let url = getUrl(forPath: PostsPaths.like) else { return }
        guard let body = try? JSONEncoder().encode(PostId(postID: id)) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter postIdToUnlike: id post'а  который нужно дизлайкнуть
    /// - Parameter completion: замыкание, в которое передается в случае удачи дизлайкнутый пост и ошибка в случае неудачи
    public func unlike(postIdToUnlike id: String,
                       completion: @escaping (Result<Post, Error>) -> Void ) {
        guard let url = getUrl(forPath: PostsPaths.unlike) else { return }
        guard let body = try? JSONEncoder().encode(PostId(postID: id)) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter postId: id post'а лайки которого нужно получить
    /// - Parameter completion: замыкание, в которое передается в случае удачи список пользователей, которые лайкнули этот пост и ошибка в случае неудачи
    public func likes(postId id: String,
                      completion: @escaping (Result<[User], Error>) -> Void ) {
        guard let url = getUrl(forPath: PostsPaths.post + "/\(id)" + PostsPaths.likes) else { return }
        guard let request = getRequest(withURL: url, method: .GET) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter image: картинка закодированная в base64 строку
    /// - Parameter completion: замыкание, в которое передается в случае удачи созданный пост и ошибка в случае неудачи
    public func createPost(image: String, description: String,
                           completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = getUrl(forPath: PostsPaths.create) else { return }
        let post = PostCreate(image: image, description: description)
        guard let body = try? JSONEncoder().encode(post) else { return }
        guard let request = getRequest(withURL: url, method: .POST, body: body) else { return }
        dataTask(request: request, completion: completion)
    }
    
    /// - Parameter completion: замыкание, в которое передается в случае удачи true и ошибка в случае неудачи
    /// - удалять токен НЕ НУЖНО
    public func deauthorize(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = getUrl(forPath: AuthentificationPaths.signout) else { return }
        guard let request = getRequest(withURL: url, method: .POST) else { return }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { completion(.failure(ErrorHandler().handleError())) }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else {
                completion(.failure(ErrorHandler().handleError(withHttpCode: response.statusCode)))
                return
            }
            completion(.success(true))
            NetworkManager.deleteToken()
        }.resume()
    }
}
