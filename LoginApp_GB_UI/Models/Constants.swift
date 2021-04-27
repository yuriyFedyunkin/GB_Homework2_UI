//
//  Constants.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 31.01.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

struct ApiData {
    static let baseUrl: String = "api.vk.com"
    static let versionAPI: String = "5.130"
    static let friendsGetMethod: String = "/method/friends.get"
    static let photoGetMethod: String = "/method/photos.getAll"
    static let groupsGetMethod: String = "/method/groups.get"
    static let newsfeedGetMethod: String = "/method/newsfeed.get"
    static let getAlbumsMethod: String = "/method/photos.getAlbums"
}
