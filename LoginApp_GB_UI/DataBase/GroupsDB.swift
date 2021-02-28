//
//  GroupsDB.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 22.02.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation
import RealmSwift

class GroupsDB {
    
    private var db: Realm?
    
    init() {
        db = try? Realm()
    }
    
    func write(_ group: Group) {
        do {
            print(db?.configuration.fileURL)
            db?.beginWrite()
            db?.add(group, update: .all)
            try db?.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func read() -> Results<Group>? {
        if let groups = db?.objects(Group.self) {
            return groups
        }
        return nil
    }
    
    func delete(_ group: Group) {
        do {
            db?.beginWrite()
            db?.delete(group)
            try db?.commitWrite()
        } catch {
            print(error)
        }
    }
}

