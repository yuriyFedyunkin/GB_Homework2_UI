//
//  NetwokManager.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 12.02.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation
import PromiseKit

class NetworkManager {
    
    static var shared = NetworkManager()
    
    let configuration = URLSessionConfiguration.default
    var urlConstructor = URLComponents()
    
    private init () {}
    
    // MARK: - Метод запроса к VK API для получения альбомов пользователя
    
    func getUserAlbumsVK(owner: User, completion: @escaping ([Album]) -> Void) {
        let session = URLSession(configuration: configuration)
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = ApiData.getAlbumsMethod
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: String(owner.id)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "need_system", value: "1"),
            URLQueryItem(name: "need_covers", value: "1")
        ]
        guard let url = urlConstructor.url else { return }
        let task = session.dataTask(with: url) { (data, _, error) in
            do {
                if data != nil {
                    let albums = try JSONDecoder().decode(VKAlbumsResponse.self, from: data!).response.items
                    completion(albums)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // MARK: - Метод запроса к VK API для получения фотографий по id альбома пользователя
    
    func getPhotoFromAlbumVK(ownerId: String, albumId: String, completion: @escaping ([Photo]) -> Void) {
        let session = URLSession(configuration: configuration)
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = ApiData.photosGetMethod
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: ownerId),
            URLQueryItem(name: "album_id", value: albumId),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "extended", value: "1")
        ]
        guard let url = urlConstructor.url else { return }
        let task = session.dataTask(with: url) { (data, _, error) in
            do {
                if data != nil {
                    let photos = try JSONDecoder().decode(VKPhotoGroupsResponse.self, from: data!).response.items
                    completion(photos)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // MARK: - Метод запроса к VK API для получения Data групп через PromiseKit
    
    func getGroupsPromise() -> Promise<Data> {
        
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = ApiData.groupsGetMethod
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "extended", value: "1"),
        ]
        
        let promise = Promise<Data> { resolver in

            if let url = urlConstructor.url {
                URLSession.shared.dataTask(with: url) { (data, _, _) in
   
                    guard let data = data else { return }
                    resolver.fulfill(data)
                }.resume()
            }
        }
        return promise
    }
    
    
    //MARK: - Метод запроса к VK API для получения данных о друзьях пользователя
    
    func getFriendsVK(completion: @escaping ([User]) -> Void) {
        let session = URLSession(configuration: configuration)
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = ApiData.friendsGetMethod
        
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
        urlConstructor.path = ApiData.groupsGetMethod
        
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
        urlConstructor.path = ApiData.photoGetMethod
        
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
