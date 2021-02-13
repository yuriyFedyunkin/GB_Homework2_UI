//
//  NetwokManager.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 12.02.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    let configuration = URLSessionConfiguration.default
    var urlConstructor = URLComponents()
    
    private init () {}
    
    func getFriends(completion: @escaping ([User]) -> Void) {
        let session = URLSession(configuration: configuration)
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = "/method/friends.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "nickname, photo_200_orig")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                if data != nil {
                    let users = try JSONDecoder().decode(VKFriendsResponse.self, from: data!).response.items
                    completion(users)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
}
