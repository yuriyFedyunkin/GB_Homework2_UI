//
//  UserModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

//struct User {
//    let userName: String
//    let userIcon: UIImage?
//    var userPhotoLibrary = [
//        UIImage(named: "img1"),
//        UIImage(named: "img2"),
//        UIImage(named: "img3"),
//        UIImage(named: "img4"),
//        UIImage(named: "img5"),
//        UIImage(named: "img6"),
//        UIImage(named: "img7"),
//    ]
//}


class User: Decodable {
    
    var firstName = ""
    var lastName = ""
    var id = 0
    var avatar: URL?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case id
        case avatar = "photo_50"
    }
    
}

struct UsersList: Decodable {
    let items: [User]
}

struct VKFriendsResponse: Decodable {
    let response: UsersList
}



/*
 {
     "response": {
         "count": 406,
         "items": [
             {
                 "first_name": "Maksim",
                 "id": 21463,
                 "last_name": "Korshunov",
                 "can_access_closed": true,
                 "is_closed": false,
                 "online": 0,
                 "nickname": "",
                 "photo_200_orig": "https://sun9-25.userapi.com/s/v1/if1/tsxw-6pDorLeGpPf6JFTkibmTeD7dVhNbs6_LUWCkkW2reyzjwo8VZDHnuzay4ScjJQftKsD.jpg?size=200x0&quality=96&crop=0,0,2047,2048&ava=1",
                 "track_code": "4e2edb99rtaDtVJLi0XOIYv2ULfyC1Vt5jUVw4oQNMsdTEdJuvLPtbCEBk2NQcVF5hfhGo1rMx8"
             },
 
 */
