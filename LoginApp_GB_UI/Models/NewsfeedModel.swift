//
//  NewsfeedModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 22.03.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

struct NewsfeedPost: Decodable {
    
    var sourceId: Int = 0
    var text: String = ""
    var comments: Int = 0
    var likes: Int = 0
    var reposts: Int = 0
    var views: Int = 0
    var authorName: String = ""
    var avatar: String = ""
    var photoUrl: String = ""
    var type: String = ""
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case text
        case comments
        case likes
        case reposts
        case views
        case count
        case type
        case photos
        case items
        case sizes
    }
    
    init(from decoder: Decoder) throws {
        // Парсим оснвоной контейнер JSON c массивом постов "items"
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)
        self.text = try container.decode(String.self, forKey: .text)
        
        self.type = try container.decode(String.self, forKey: .type)
        let photosContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .photos)
        var photoItemsContainer = try photosContainer.nestedUnkeyedContainer(forKey: .items)
        while !photoItemsContainer.isAtEnd {
            let size = try photoItemsContainer.decode(Sizes.self)
            if size.type == "z" || size.type == "y" || size.type == "x" {
                self.photoUrl = size.url
            }
        }
        
        // Парсим контейнер с комментами
        let commentsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .comments)
        self.comments = try commentsContainer.decode(Int.self, forKey: .count)
        // Парсим контейнер с лайками
        let likesContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .likes)
        self.likes = try likesContainer.decode(Int.self, forKey: .count)
        // Парсим контейнер с репостами
        let repostsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .reposts)
        self.reposts = try repostsContainer.decode(Int.self, forKey: .count)
        // Парсим контейнер с количеством просмотров
        let viewsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .views)
        self.views = try viewsContainer.decode(Int.self, forKey: .count)
    }
}


struct NewsfeedDetails: Decodable {
    let items: [NewsfeedPost]
    let groups: [Group]
}

struct VKNewsfeedResponse: Decodable {
    let response: NewsfeedDetails
}
