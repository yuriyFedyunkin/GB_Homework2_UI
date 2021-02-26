//
//  SearchGroupsController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class SearchGroupsController: UITableViewController {
    
    var availableGroups = [Group]()
    
    private var groupsRealm = GroupsDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.getGroupsVK() { [weak self] userGroups in
            DispatchQueue.main.async {
                self?.groupsRealm.write(userGroups)
                self?.readGroupsRealm()
            }
        }
        
        let gradient = GradientView()
        gradient.setupGradient(startColor: .blue, endColor: .systemGray, startLocation: 0, endLocation: 1, startPoint: .zero, endPoint: CGPoint(x:0, y: 1))
        
        gradient.alpha = 0.6
        tableView.backgroundView = gradient
    }
    
    // MARK: - Методы добавления групп в Realm и закрузка из Realm
    
    private func addToGroupsRealm(groups: [Group]) {
        groupsRealm.write(groups)
    }
    
    private func readGroupsRealm() {
        groupsRealm.read()?.forEach{availableGroups.append($0)}
        tableView.reloadData()
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
        
        cell.configure(withGroup: group)

        return cell
    }

}
