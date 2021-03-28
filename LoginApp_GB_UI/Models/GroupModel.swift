//
//  GroupModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class Group: Decodable, Equatable {
 
    var name = ""
    var id = 0
    var avatar: URL?
    var isMember = 0
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case avatar = "photo_50"
        case isMember = "is_member"
    }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.id == rhs.id
    }
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
