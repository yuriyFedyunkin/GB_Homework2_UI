//
//  NewsfeedModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 22.03.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

struct NewsfeedPost: Decodable {
    
    var sourceId: Int = 0
    var text: String = ""
    var comments: Int = 0
    var likes: Int = 0
    var reposts: Int = 0
    var views: Int?
    var authorName: String = ""
    var avatar: String = ""
    var type: String = ""
    var date: TimeInterval = 0
    var photoUrl: String?
    var photoWidth: Int?
    var photoHeigth: Int?
    
    var photoAspectRatio: CGFloat? {
        if photoWidth != nil && photoHeigth != nil {
            return CGFloat(photoHeigth!) / CGFloat(photoWidth!)
        }
        return nil
    }
        
    
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
        case date
        case attachments
        
    }
    
    init(from decoder: Decoder) throws {
        // Парсим оснвоной контейнер JSON c массивом постов "items"
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)
        self.date = try container.decode(TimeInterval.self, forKey: .date)
        
        self.type = try container.decode(String.self, forKey: .type)
        
        if self.type == "post" {
            // Парсим текст поста
            self.text = try container.decode(String.self, forKey: .text)
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
            if let viewsContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .views) {
                self.views = try viewsContainer.decode(Int.self, forKey: .count)
            }
            
            if let attachments = try? container.decode([Attachment].self, forKey: .attachments) {
                if let photo = attachments.first (where: { $0.type == "photo" }),
                   let xSize = photo.photo?.sizes.first(where: { $0.type == "x" }) {
                    let urlString = xSize.url
                    self.photoUrl = urlString
                    self.photoWidth = xSize.width
                    self.photoHeigth = xSize .height
                }
                else if let photo = attachments.first (where: { $0.type == "link" }),
                   let xSize = photo.link?.photo.sizes.first(where: { $0.type == "x"}) {
                    let urlString = xSize.url
                    self.photoUrl = urlString
                    self.photoWidth = xSize.width
                    self.photoHeigth = xSize .height
                }
            }
        }
        /*
            else if self.type == "photo" {
            let photosContainer = try container.decode(PhotosContainer.self, forKey: .photos)
            if let photo = photosContainer.items.first {
                self.likes = photo.likes
                self.comments = photo.comments
                self.reposts = photo.reposts
                self.photoUrl = photo.sizes.last?.url ?? ""
            }
        }
        */
    }
}


struct NewsfeedDetails: Decodable {
    let items: [NewsfeedPost]
    let groups: [Group]
    let profiles: [User]
    var nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case items
        case groups
        case profiles
        case nextFrom = "next_from"
    }
}

struct VKNewsfeedResponse: Decodable {
    let response: NewsfeedDetails
}

// Cтруктура для парсина массива "Attachments", чтобы достать фото, прикрепленные к новости

struct Attachment: Decodable {
    let type: String
    let photo: AttachedPhoto?
    let link: LinkPhoto?

    struct AttachedPhoto: Decodable {
        let sizes: [Sizes]
    }
    struct LinkPhoto: Decodable {
        let photo: AttachedPhoto
    }
}

//MARK: - Логика для новостей типа "Photo"

/*
struct PhotosContainer: Decodable {
    let items: [PhotoPost]
}

struct PhotoPost: Decodable {
    let sizes: [Sizes]
    let likes: Int
    let comments: Int
    let reposts: Int
    
    enum CodingKeys: String, CodingKey {
        case likes
        case reposts
        case comments
        case count
        case sizes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let commentsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .comments)
        self.comments = try commentsContainer.decode(Int.self, forKey: .count)
        // Парсим контейнер с лайками
        let likesContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .likes)
        self.likes = try likesContainer.decode(Int.self, forKey: .count)
        // Парсим контейнер с репостами
        let repostsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .reposts)
        self.reposts = try repostsContainer.decode(Int.self, forKey: .count)
        
        let sizes = try container.decode([Sizes].self, forKey: .sizes)
        self.sizes = sizes
    }
    
}
*/
