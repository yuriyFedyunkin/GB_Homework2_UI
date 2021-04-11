//
//  GetGroupsByRequestVK.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 01.02.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

class GetGroupsByRequestVK {
    
    func searchGroup(query: String) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        // Создаем конструктор для url + cхема + хост + путь
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = "/method/groups.search"
        
        // параметры запроса
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "v", value: ApiData.versionAPI)
        ]
        
        guard let url = urlConstructor.url else { return }
        
        let task = session.dataTask(with: url) { (data, response, error)  in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json as Any)
        }
        task.resume()
        
    }
    
}
