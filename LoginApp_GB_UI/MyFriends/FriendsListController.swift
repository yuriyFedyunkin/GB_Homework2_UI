//
//  FriendsListController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class FriendsListController: UITableViewController {

    
    var friendsList = [
        "Frodo",
        "Aragron",
        "Gendalf"
    ]
    
    var friendsIconList = [
        UIImage(named: "frodoIcon"),
        UIImage(named: "aragornIcon"),
        UIImage(named: "gendalfIcon")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let friend = friendsList[indexPath.row]
        let icon = friendsIconList[indexPath.row]
        cell.friendName.text = friend
        cell.friendIcon.image = icon

        return cell
    }
    
}
