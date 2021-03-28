//
//  Session.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 30.01.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

struct Session {
    
    static var shared = Session()
    
    var token: String = ""
    var userId: Int = 0
    
    private init() {}
    
}
