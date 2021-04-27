//
//  AlbumModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 27.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation
import RealmSwift


class Album: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var title = ""
    @objc dynamic var size = 0
    @objc dynamic var coverURL = ""
    var photos = List<Photo>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case title
        case size
        case coverURL = "thumb_src"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)
        self.title = try container.decode(String.self, forKey: .title)
        self.size = try container.decode(Int.self, forKey: .size)
        self.coverURL = try container.decode(String.self, forKey: .coverURL)
    }
}

struct UserAlbumsList: Decodable {
    let items: [Album]
}

struct VKAlbumsResponse: Decodable {
    let response: UserAlbumsList
}
