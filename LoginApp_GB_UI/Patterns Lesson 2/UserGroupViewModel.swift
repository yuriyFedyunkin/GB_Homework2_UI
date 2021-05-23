//
//  UserGroupViewModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 23.05.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation

struct UserGroupViewModel {
    let name: String
    let imageURLString: String
}


class UserGroupViewModelFactory {
    func createViewModel(group: Group) -> UserGroupViewModel {
        .init(name: group.name, imageURLString: group.avatar)
    }
}
