//
//  SearchGroupsController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit
import PromiseKit

class SearchGroupsController: UITableViewController {
    
    var availableGroups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly {
            NetworkManager.shared.getGroupsPromise()
        }.then { (data) in
            self.groupsPromiseParser(data)
        }.done(on: .main) { (groups) in
            self.availableGroups = groups
            self.tableView.reloadData()
        }.catch { (error) in
            print(error.localizedDescription)
        }
        
//        NetworkManager.shared.getGroupsVK() { [weak self] userGroups in
//            DispatchQueue.main.async {
//                self?.availableGroups = userGroups
//                self?.tableView.reloadData()
//            }
//        }
        
        let gradient = GradientView()
        gradient.setupGradient(startColor: .blue, endColor: .systemGray, startLocation: 0, endLocation: 1, startPoint: .zero, endPoint: CGPoint(x:0, y: 1))
        
        gradient.alpha = 0.6
        tableView.backgroundView = gradient
    }
    
    private func groupsPromiseParser(_ data: Data) -> Promise<[Group]> {
        let promise = Promise<[Group]> { resolver in
            do {
                let groups = try JSONDecoder().decode(VKUserGroupsResponse.self, from: data).response.items
                resolver.fulfill(groups)
            } catch {
                print(error.localizedDescription)
                resolver.reject(error)
            }
        }
        return promise
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableGroupsCell", for: indexPath) as! UserGroupCell
        let group = availableGroups[indexPath.row]
        
        cell.configure(withGroup: group)

        return cell
    }

}
