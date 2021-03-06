//
//  GetGroupsVK.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 31.01.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

class GetGroupsVK {
    
    static func sendRequest() {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        // Создаем конструктор для url + cхема + хост + путь
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = "/method/groups.get"
        
        // параметры запроса
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "extended", value: "1")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        let task = session.dataTask(with: url) { (data, response, error)  in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json as Any)
        }
        task.resume()
    }
    
}
