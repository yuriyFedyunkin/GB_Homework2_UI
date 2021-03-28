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
        User(userName: "Frodo", userIcon: UIImage(named: "Frodo"), userPhotoLibrary: [UIImage(named: "testPhoto")!, UIImage(named: "Frodo")!]),
        User(userName: "Aragorn", userIcon: UIImage(named: "Aragorn"), userPhotoLibrary: [UIImage(named: "Aragorn")!, UIImage(named: "testPhoto")!]),
        User(userName: "Gendalf", userIcon: UIImage(named: "Gendalf"), userPhotoLibrary: [UIImage(named: "testPhoto")!, UIImage(named: "Gendalf")!])
    ]
    
    // Словарь и массив для создания секций по первой букве имени User
//    var friendsDict = [String: [String]]()
//    var friendsSectionTitle = [String]()
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    //Создаем словаррь имен друзей
        //createFriendsDict()
    }
    
    // Segue с передачей библиотеки фото юзера из массива в PhotoCollection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLibrary" {
            guard let destinationVC = segue.destination as? PhotoCollectionController else { return }
            if let indexPath = tableView.indexPathForSelectedRow {
                let user = friendsList[indexPath.row]
                destinationVC.photoLibrary.append(contentsOf: user.userPhotoLibrary)
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        //return friendsSectionTitle[section]
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsList.count
//        let nameKey = friendsSectionTitle[section]
//        guard let nameValues = friendsDict[nameKey] else { return 0 }
//
//        return nameValues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        
//        let nameKey = friendsSectionTitle[indexPath.section]
//        
//        if let nameValues = friendsDict[nameKey] {
//            cell.friendName.text = nameValues[indexPath.row]
//            cell.friendIcon.image = UIImage(named: nameValues[indexPath.row])
//        }
        
        let friend = friendsList[indexPath.row]
        
        cell.friendName.text = friend.userName
        cell.friendIcon.image = friend.userIcon

        return cell
    }
    
    //MARK: - Helper method
//    func createFriendsDict() {
//        var names = [String]()
//        for user in friendsList {
//            names.append(user.userName)
//        }
//
//        for name in names {
//            let firstLetterIndex = name.index(name.startIndex, offsetBy: 1)
//            let nameKey = String(name [..<firstLetterIndex])
//
//            if var nameValue = friendsDict[nameKey] {
//                nameValue.append(name)
//                friendsDict[nameKey] = nameValue
//            } else {
//                friendsDict[nameKey] = [name]
//            }
//        }
//        friendsSectionTitle = [String](friendsDict.keys)
//        friendsSectionTitle = friendsSectionTitle.sorted(by: { $0 < $1 })
//    }
    
    
}
