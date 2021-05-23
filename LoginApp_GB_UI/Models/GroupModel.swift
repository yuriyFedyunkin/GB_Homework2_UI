//
//  GroupModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit
import RealmSwift

protocol GroupProtocol {
    var name: String { get }
    var id: Int { get }
    var avatar: String { get }
}

class Group: Object, Decodable, GroupProtocol {
 
    @objc dynamic var name = ""
    @objc dynamic var id = 0
    @objc dynamic var avatar = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case avatar = "photo_50"
    }
    
    func toFirebaseGroup() -> FirebaseGroup {
        return FirebaseGroup(id: self.id, name: self.name)
    }
    
//    static func == (lhs: Group, rhs: Group) -> Bool {
//        lhs.id == rhs.id
//    }
}

struct UserGroupsList: Decodable {
    let items: [Group]
}

struct VKUserGroupsResponse: Decodable {
    let response: UserGroupsList
}

//struct Group: Equatable {
//    let groupName: String?
//    let groupIcon: UIImage?
//}
