//
//  PhotoModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 14.02.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

class Photo: Decodable {
    var url = ""
    var likes = 0
    
    enum CodingKeys: String, CodingKey {
        case sizes
        case likes
    }
    
    enum SizesKeys: String, CodingKey {
        case url
    }
    
    enum LikesKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let likesValues = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = (try likesValues.decode(Int.self, forKey: .count)) + (try likesValues.decode(Int.self, forKey: .userLikes))
        
        var sizesValue = try values.nestedUnkeyedContainer(forKey: .sizes)
        let firstPhotoSize = try sizesValue.nestedContainer(keyedBy: SizesKeys.self)
        self.url = try firstPhotoSize.decode(String.self, forKey: .url)
        
    }
    
}

struct UserPhotoesList: Decodable {
    let items: [Photo]
}

struct VKPhotoGroupsResponse: Decodable {
    let response: UserPhotoesList
}

