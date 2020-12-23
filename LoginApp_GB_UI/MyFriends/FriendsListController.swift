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
        User(userName: "Frodo", userIcon: UIImage(named: "Frodo")),
        User(userName: "Aragorn", userIcon: UIImage(named: "Aragorn")),
        User(userName: "Gendalf", userIcon: UIImage(named: "Gendalf")),
        User(userName: "Bilbo", userIcon: UIImage(named: "Bilbo")),
        User(userName: "Legolas", userIcon: UIImage(named: "Legolas")),
        User(userName: "Gimli", userIcon: UIImage(named: "Gimli")),
        User(userName: "Sam", userIcon: UIImage(named: "Sam"))
    ]
    
    // Словарь и массив для создания секций по первой букве имени User
    var friendsDict = [String: [User]]()
    var friendsSectionTitle = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Создаем словаррь имен друзей
        createFriendsDict()
        
        //Градиенти для tableView
        let gradient = GradientView()
        gradient.setupGradient(startColor: .blue, endColor: .systemGray, startLocation: 0, endLocation: 1, startPoint: .zero, endPoint: CGPoint(x:0, y: 1))
        
        gradient.alpha = 0.6
        tableView.backgroundView = gradient
    }
    
    //Segue с передачей библиотеки фото юзера из массива в PhotoCollection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLibrary" {
            guard let destinationVC = segue.destination as? PhotoCollectionController else { return }
            if let indexPath = tableView.indexPathForSelectedRow {
                let key = friendsSectionTitle[indexPath.section]
                let friend = friendsDict[key]![indexPath.row]
                destinationVC.photoLibrary.append(contentsOf: friend.userPhotoLibrary)
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.alpha = 0.3
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return friendsSectionTitle.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsSectionTitle[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nameKey = friendsSectionTitle[section]
        guard let nameValues = friendsDict[nameKey] else { return 0 }

        return nameValues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        
        let nameKey = friendsSectionTitle[indexPath.section]
        let friend = friendsDict[nameKey]![indexPath.row]
        
        cell.friendName.text = friend.userName
        cell.friendIcon.image = friend.userIcon
        
        return cell
    }
    
    // Боковая панель для поиска по первой букве имени
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsSectionTitle
    }
    
    //MARK: - Helper method
    // Сортировка друзей по первой букве в имени
    func createFriendsDict() {
        for friend in friendsList {
            let firstLetterIndex = String(friend.userName.first!)
            if friendsDict[firstLetterIndex] != nil {
                friendsDict[firstLetterIndex]!.append(friend)
            } else {
                friendsDict[firstLetterIndex] = [friend]
            }
        }
        friendsSectionTitle = friendsDict.keys.sorted(by: { $0 < $1 })
    }
    
}
