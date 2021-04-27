//
//  UserModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit
import RealmSwift

class User: Object, Decodable {
    
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var id = 0
    @objc dynamic var avatar = ""
    var photos = List<Photo>()
    var albums = List<Album>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
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

