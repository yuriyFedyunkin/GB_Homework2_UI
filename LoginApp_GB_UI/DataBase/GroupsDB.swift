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
    
    func write(_ groups: [Group]) {
        do {
            db?.beginWrite()
            db?.add(groups, update: .all)
            try db?.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func read() -> [Group]? {
        if let groups = db?.objects(Group.self) {
            return Array(groups)
        }
        return nil
    }
}
