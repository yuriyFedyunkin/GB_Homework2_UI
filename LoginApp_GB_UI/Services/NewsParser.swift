//
//  NewsParser.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 29.03.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

class NewsParser {
    
    
    func parseNews(completion: @escaping ([NewsfeedPost]) -> Void) {
        
        let configuration = URLSessionConfiguration.default
        var urlConstructor = URLComponents()
        let session = URLSession(configuration: configuration)
        urlConstructor.scheme = "https"
        urlConstructor.host = ApiData.baseUrl
        urlConstructor.path = "/method/newsfeed.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: ApiData.versionAPI),
            URLQueryItem(name: "fields", value: "first_name,last_name,name,photo_50"),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "source_ids", value: "friends,groups")
        ]
        
        guard let url = urlConstructor.url else { return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                if data != nil {
                    let feed = try JSONDecoder().decode(VKNewsfeedResponse.self, from: data!).response
                    let postsStorage = PostsStore(posts: feed.items, groups: feed.groups, users: feed.profiles)
                    postsStorage.mergePostsWithAuthors(completion: completion)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

class PostsStore {
    private var postsStorage: [NewsfeedPost]
    private var groupsStorage: [Group]
    private var profileStorage: [User]
    private let syncQueue = DispatchQueue(label: "NewsStoreQueue", attributes: .concurrent)
    
    init(posts: [NewsfeedPost], groups: [Group], users: [User]) {
        self.postsStorage = posts
        self.groupsStorage = groups
        self.profileStorage = users
    }
    
    func mergePostsWithAuthors(completion: @escaping ([NewsfeedPost]) -> ()) {
        let dispatchGroup = DispatchGroup()
        
        for index in 0..<postsStorage.count {
            DispatchQueue.global().async(group: dispatchGroup) { [weak self] in
                guard let self = self else { return }
                let post = self.getPost(at: index)
                let sourceId = post.sourceId
                
                if sourceId < 0 {
                    guard let group = self.getGroup(id: -sourceId) else { return }
                    self.merge(group: group, toPostsAtIndex: index)
                } else if sourceId > 0 {
                    guard let profile = self.getProfile(id: sourceId) else { return }
                    self.merge(profile: profile, toPostAtIndex: index)
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(self.getPosts())
        }
    }
    
    func merge(group: Group, toPostsAtIndex index: Int) {
        syncQueue.async(flags: .barrier) {
            self.postsStorage[index].authorName = group.name
            self.postsStorage[index].avatar = group.avatar
        }
    }
    
    func merge(profile: User, toPostAtIndex index: Int) {
        syncQueue.async(flags: .barrier) {
            self.postsStorage[index].authorName = profile.firstName + " " + profile.lastName
            self.postsStorage[index].avatar = profile.avatar
        }
    }
    
    func getPosts() -> [NewsfeedPost] {
        var posts: [NewsfeedPost] = []
        syncQueue.sync {
            posts = postsStorage
        }
        return posts
    }
    
    func getPost(at index: Int) -> NewsfeedPost {
        var post: NewsfeedPost!
        syncQueue.sync(flags: .barrier) {
            post = postsStorage[index]
        }
        return post
    }
    
    func getGroup(id: Int) -> Group? {
        var group: Group?
        syncQueue.sync {
            group = groupsStorage.first(where: { $0.id == id })
        }
        return group
    }
    
    func getProfile(id: Int) -> User? {
        var profile: User?
        syncQueue.sync {
            profile = profileStorage.first(where: { $0.id == id })
        }
        return profile
    }
    
}
