//
//  SearchGroupsController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class SearchGroupsController: UITableViewController {
    
    var availableGroups = [
        Group(groupName: "Harry Potter", groupIcon: UIImage(named: "hpIcon")),
        Group(groupName: "The Game Of Thrones", groupIcon: UIImage(named: "gotIcon")),
        Group(groupName: "Lord Of The Rings", groupIcon: UIImage(named: "lorIcon")),
        Group(groupName: "Hobbit", groupIcon: UIImage(named: "hobbitIcon"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = GradientView()
        gradient.setupGradient(startColor: .blue, endColor: .systemGray, startLocation: 0, endLocation: 1, startPoint: .zero, endPoint: CGPoint(x:0, y: 1))
        
        gradient.alpha = 0.6
        tableView.backgroundView = gradient
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return availableGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableGroupsCell", for: indexPath) as! UserGroupCell
        let group = availableGroups[indexPath.row]
        
        cell.groupNameText.text = group.groupName
        cell.groupIcon.image = group.groupIcon

        return cell
    }

}
