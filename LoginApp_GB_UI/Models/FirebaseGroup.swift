//
//  FirebaseGroup.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 06.03.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation
import Firebase

class FirebaseGroup {
    
    let id: Int
    let name: String
    let ref: DatabaseReference?
    
    init (id: Int, name: String) {
        self.id = id
        self.name = name
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? Int,
              let name = value["name"] as? String
        else { return nil }
        
        self.ref = snapshot.ref
        self.id = id
        self.name = name
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "name": name
        ]
    }
    
}
