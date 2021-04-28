//
//  UsersDB.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 22.02.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import UIKit
import RealmSwift

class UsersDB {
    
    static var shared = UsersDB()
    
    private var db = try? Realm()
    
    private init() {}
    
    func write(_ users: [User]) {
        do {
            print(db?.configuration.fileURL)
            db?.beginWrite()
            db?.add(users, update: .all)
            try db?.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func writePhotos(_ photos: [Photo], user: User) {
        do {
            db?.beginWrite()
            
            let photoList = List<Photo>()
            photoList.append(objectsIn: photos)
            user.photos = photoList
            
            db?.add(user, update: .all)
            try db?.commitWrite()
            
        } catch {
            print(error)
        }
    }
    
    func wtiteAlbums(_ albums: [Album], user: User) {
        do {
            db?.beginWrite()
            
            let albums = List<Album>()
            albums.append(objectsIn: albums)
            user.albums = albums
            
            db?.add(user, update: .all)
            try db?.commitWrite()
            
        } catch {
            print(error)
        }
    }
    
    
    func read() -> [User]? {
        if let users = db?.objects(User.self) {
            return Array(users)
        }
        return nil
    }
    
    func readPhotos(user: User) -> [Photo] {
        return Array(user.photos)
    }
    
    func readAlbums(user: User) -> [Album] {
        return Array(user.albums)
    }
}

