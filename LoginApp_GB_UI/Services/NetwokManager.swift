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
    
 
    // MARK: - Метод запроса к VK API для получения  ленты новостей
    
    func getNewsfeedVK(completion1: @escaping ([NewsfeedPost]) -> Void, completion2: @escaping ([Group]) -> Void) {
        let session = URLSession(configuration: configuration)
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = "/method/newsfeed.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "fields", value: "first_name,last_name,name"),
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "source_ids", value: "groups")
        ]
        
        guard let url = urlConstructor.url else { return }

        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                if data != nil {
                    let feed = try JSONDecoder().decode(VKNewsfeedResponse.self, from: data!).response
                    completion1(feed.items)
                    completion2(feed.groups)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    //MARK: - Метод запроса к VK API для получения данных о друзьях пользователя
    
    func getFriendsVK(completion: @escaping ([User]) -> Void) {
        let session = URLSession(configuration: configuration)
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
        
        guard let url = urlConstructor.url else { return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                if data != nil {
                    let users = try JSONDecoder().decode(VKFriendsResponse.self, from: data!).response.items
                    completion(users)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    //MARK: - Метод запроса к VK API для получения данных о гурппах пользователя
    
    func getGroupsVK(completion: @escaping ([Group]) -> Void) {
        let session = URLSession(configuration: configuration)
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = "/method/groups.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "extended", value: "1"),
        ]
        guard let url = urlConstructor.url else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                if data != nil {
                    let userGroups = try JSONDecoder().decode(VKUserGroupsResponse.self, from: data!).response.items
                    completion(userGroups)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    //MARK: - Метод запроса к VK API для получения фотогрфий пользователя
    
    func getPhotosVK(owener: User, completion: @escaping ([Photo]) -> Void) {
        let session = URLSession(configuration: configuration)
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = "/method/photos.getAll"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: String(owener.id)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "no_service_albums", value: "0"),
            URLQueryItem(name: "extended", value: "1")
        ]
        guard let url = urlConstructor.url else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                if data != nil {
                    let photos = try JSONDecoder().decode(VKPhotoGroupsResponse.self, from: data!).response.items
                    completion(photos)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
}
