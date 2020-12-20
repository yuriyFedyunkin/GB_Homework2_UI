//
//  UserModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

struct User {
    let userName: String
    let userIcon: UIImage?
    var userPhotoLibrary = [
        UIImage(named: "img1"),
        UIImage(named: "img2"),
        UIImage(named: "img3"),
        UIImage(named: "img4"),
        UIImage(named: "img5"),
        UIImage(named: "img6"),
        UIImage(named: "img7"),
    ]
}
