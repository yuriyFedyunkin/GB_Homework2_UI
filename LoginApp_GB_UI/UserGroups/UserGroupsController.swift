//
//  UserGroupsController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class UserGroupsController: UITableViewController {

    var userGroups = [
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
    
    @IBAction func addGroup(segue: UIStoryboardSegue){
        if segue.identifier == "addGroup" {
            guard let searchGroupsController = segue.source as? SearchGroupsController else { return }
            if let indexPath = searchGroupsController.tableView.indexPathForSelectedRow {
                let group = searchGroupsController.availableGroups[indexPath.row]
                if !userGroups.contains(group) {
                    userGroups.append(group)
                    tableView.reloadData()
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! UserGroupCell
        let group = userGroups[indexPath.row]
        
        cell.groupNameText.text = group.groupName
        cell.groupIcon.image = group.groupIcon

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
