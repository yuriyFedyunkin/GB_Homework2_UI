//
//  SizesModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 27.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation
import RealmSwift

class Sizes: Object, Decodable {
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    
}
