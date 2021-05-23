//
//  UserGroupsController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class UserGroupsController: UITableViewController {

    private var firebaseGroups = [FirebaseGroup]()
    private let ref = Database.database().reference(withPath: String(Session.shared.userId))
    private let gradient = GradientView()
    
    var userGroups: Results<Group>?
    private var groupsRealm = GroupsDB()
    var token: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseGroupsHandler()
        pairTableAndRealm()
        
        gradient.setupGeneralGradientView(for: self.tableView)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue){
        if segue.identifier == "addGroup" {
            guard let searchGroupsController = segue.source as? SearchGroupsController else { return }
            if let indexPath = searchGroupsController.tableView.indexPathForSelectedRow {
                let group = searchGroupsController.availableGroups[indexPath.row]
                groupsRealm.write(group)  // записываем выбранную группу в Realm
                
                // Записываем группу в Firebase
                let groupFB = group.toFirebaseGroup()
                let groupRef = self.ref.child(String(groupFB.id))
                groupRef.setValue(groupFB.toAnyObject())
                }
            }
        }

    // MARK: - Обработка групп из Realm + отслеживание изменений
    func pairTableAndRealm() {
        userGroups = groupsRealm.read()
        token = userGroups?.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        })
    }
    
    // MARK: - Обработка групп из Firebase
    
    func firebaseGroupsHandler() {
        ref.observe(.value) { (snapshot) in
            var groups: [FirebaseGroup] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let group = FirebaseGroup(snapshot: snapshot) {
                    groups.append(group)
                }
            }
            self.firebaseGroups = groups
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groups = userGroups else { return 0 }
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! UserGroupCell
        
        if let group = userGroups?[indexPath.row] {
            let groupViewModel = UserGroupViewModel(name: group.name, imageURLString: group.avatar)
            cell.configure(withGroup: groupViewModel)
        }
        return cell
    }
    
    // удаление группы из Realm и с TableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let group = userGroups?[indexPath.row] else { return }
        if editingStyle == .delete {
            
            // Удаляем гуппу из Firebase
            for groupFB in firebaseGroups {
                if group.id == groupFB.id {
                    groupFB.ref?.removeValue()
                }
            }
            // Удаляем группу из Realm
            groupsRealm.delete(group)
        }
    }
}

