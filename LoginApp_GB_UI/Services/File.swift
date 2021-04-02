//
//  File.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 02.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

class ReloadFriendsListController: Operation {
    
    var controller: FriendsListController
    
    init(controller: FriendsListController) {
        self.controller = controller
    }
    
    override func main() {
        guard let parseData = dependencies.first as? ParseFriendsDataOperation else { return }
        controller.addToUsersRealm(users: parseData.outputData)
        controller.readUsersRealm()
    }
}


class ParseFriendsDataOperation: AsyncOperation {
    var outputData: [User] = []
    
    override func main() {
        guard let getFriendsDataOperation = dependencies.first as? GetFriendsDataOperation,
              let data = getFriendsDataOperation.friendsData else { return }
        do {
            let users = try JSONDecoder().decode(VKFriendsResponse.self, from: data).response.items
            outputData = users
        } catch {
            print(error)
        }
    }
}

class GetFriendsDataOperation: AsyncOperation {
    
    var friendsData: Data?
    private var dataTask: URLSessionDataTask?

    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    override func main() {
        guard let request = getFriendsUrlRequest() else { return }
        URLSession.shared.dataTask(with: request) { [weak self] (data, _, _) in
            self?.friendsData = data
            self?.state = .finished
        }.resume()
    }
    
    
    func getFriendsUrlRequest() -> URLRequest? {
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = "/method/friends.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "nickname, photo_50")
        ]
        
        guard let url = urlConstructor.url else { return nil }
        
        return URLRequest(url: url)
    }
}


// Async Opearaion class

class AsyncOperation: Operation {
    enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    override func cancel() {
        super.cancel()
        state = .finished
    }
}
