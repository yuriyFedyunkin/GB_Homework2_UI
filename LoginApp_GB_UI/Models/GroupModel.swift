//
//  GroupModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

//struct Group: Equatable {
//    let groupName: String?
//    let groupIcon: UIImage?
//}

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

/*
 
 {
     "response": {
         "count": 130,
         "items": [
             {
                 "id": 57466174,
                 "name": "Уютное гнездышко / поиск жилья и соседей / СПБ",
                 "screen_name": "yuytnoe_gnezdishko",
                 "is_closed": 0,
                 "type": "page",
                 "is_admin": 0,
                 "is_member": 1,
                 "is_advertiser": 0,
                 "photo_50": "https://sun9-69.userapi.com/s/v1/if1/KCswdcH6iDNy8RSdyCqBGnsVITvVxhFc3tDDNkmtz5dEQMHWZogRkXJIiBxDHxWA3CLOLF8j.jpg?size=50x0&quality=96&crop=58,0,460,460&ava=1",
                 "photo_100": "https://sun9-69.userapi.com/s/v1/if1/EBDGies3cSTCy3EwukHJ4BqYBHkI7WTIkzJxRemYyvXgqoNp151eqoiyBNwaHLLUaHMa-nu1.jpg?size=100x0&quality=96&crop=58,0,460,460&ava=1",
                 "photo_200": "https://sun9-69.userapi.com/s/v1/if1/4zb_f99krfp-YVuvxUWf8VAjKQRSnHvBAFMk6cLkLn-XvhgK0iB23aqs2HOzOy4nYa8zwqLM.jpg?size=200x0&quality=96&crop=58,0,460,460&ava=1"
             },
             {
                 "id": 31556867,
                 "name": "Типичный Калининград",
                 "screen_name": "typikal",
                 "is_closed": 0,
                 "type": "page",
                 "is_admin": 0,
                 "is_member": 1,
                 "is_advertiser": 0,
                 "photo_50": "https://sun9-43.userapi.com/s/v1/if1/RgtJAXBuaPx3ifmACzmfnLLfUZyAUiInRC-EKZzzUi65nqI56UmTBwfH2pYnZW0N7ZK43I0N.jpg?size=50x0&quality=96&crop=0,0,1000,1000&ava=1",
                 "photo_100": "https://sun9-43.userapi.com/s/v1/if1/ZIvUbb-IgHAD73J4mi2FAuDdjh6I_UoId1X6YPgp54t_-FjKkf4yb6MojqT-huv5F4ECPVe9.jpg?size=100x0&quality=96&crop=0,0,1000,1000&ava=1",
                 "photo_200": "https://sun9-43.userapi.com/s/v1/if1/aJyD9NuLDXygYuyHk-epIsWbNmoK06VBWWK0Jnfzcmj_lUmRsJCf8IYcaJzF9MC2lXtnywDd.jpg?size=200x0&quality=96&crop=0,0,1000,1000&ava=1"
             },
 
 */
