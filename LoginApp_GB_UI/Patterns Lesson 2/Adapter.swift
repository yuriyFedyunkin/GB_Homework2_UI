//
//  Adapter.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 23.05.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

class UserToGroupAdapter: GroupProtocol {
    
    let user: User
    
    var name: String {
        user.firstName + " " + user.lastName
    }
    var id: Int {
        user.id
    }
    var avatar: String {
        user.avatar
    }
    
    init(user: User) {
        self.user = user
    }  
}
