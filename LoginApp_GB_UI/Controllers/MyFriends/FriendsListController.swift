//
//  FriendsListController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class FriendsListController: UITableViewController {

    private var friendsList = [User]()
    let friendsOperationQueue = OperationQueue()
    
    // Фото сервис для настройки работы Cache
    var photoService: PhotoService?
    
    // Словарь и массив для создания секций по первой букве имени User
    private var friendsDict = [String: [User]]()
    private var friendsSectionTitle = [String]()

    // Массив для списка друзей, отфилтрованных через SearchController
    private var filtredFriends = [User]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
   
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoService = PhotoService(container: tableView)
        getFriendsOperations()
 
        //Градиенти для tableView
        let gradient = GradientView()
        gradient.setupGradient(startColor: .blue, endColor: .systemGray, startLocation: 0, endLocation: 1, startPoint: .zero, endPoint: CGPoint(x:0, y: 1))
        gradient.alpha = 0.6
        tableView.backgroundView = gradient
        
        //Настройка SearchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Функция для Opeartion Queue
    
    func getFriendsOperations() {
        let getFrinedsDataOperation = GetFriendsDataOperation()
        friendsOperationQueue.addOperation(getFrinedsDataOperation)
        
        let parseFriendsOpearation = ParseFriendsDataOperation()
        parseFriendsOpearation.addDependency(getFrinedsDataOperation)
        friendsOperationQueue.addOperation(parseFriendsOpearation)
        
        let reloadControllerOpearaion = ReloadFriendsListController(controller: self)
        reloadControllerOpearaion.addDependency(parseFriendsOpearation)
        OperationQueue.main.addOperation(reloadControllerOpearaion)
    }
    
    // MARK: - Методы добавления друзей в Realm и закрузка из Realm
    
    func addToUsersRealm(users: [User]) {
        UsersDB.shared.write(users)
    }
    
    func readUsersRealm() {
        UsersDB.shared.read()?.forEach{friendsList.append($0)}
        createFriendsDict()
        tableView.reloadData()
    }
    
    
    //MARK: - Segue с передачей библиотеки фото юзера из массива в PhotoCollection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLibrary" {
            guard let destinationVC = segue.destination as? PhotoCollectionController else { return }
            if let indexPath = tableView.indexPathForSelectedRow {
                let friend: User
                if isFiltering {
                    friend = filtredFriends[indexPath.row]
                } else {
                    let key = friendsSectionTitle[indexPath.section]
                    friend = friendsDict[key]![indexPath.row]
                }
                destinationVC.navigationItem.title = "\(friend.firstName) \(friend.lastName) photos"
                destinationVC.currentUser = friend
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.alpha = 0.3
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        return friendsSectionTitle.count

    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return "Search result"
        }
        return friendsSectionTitle[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filtredFriends.count
        }

        let nameKey = friendsSectionTitle[section]
        guard let nameValues = friendsDict[nameKey] else { return 0 }

        return nameValues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell

        if isFiltering {
            let friend = filtredFriends[indexPath.row]
            cell.configure(withUser: friend)
            cell.friendIcon.image = photoService?.photo(atIndexpath: indexPath, byUrl: friend.avatar)

        } else {
            let nameKey = friendsSectionTitle[indexPath.section]
            let friend = friendsDict[nameKey]![indexPath.row]
            cell.configure(withUser: friend)
            cell.friendIcon.image = photoService?.photo(atIndexpath: indexPath, byUrl: friend.avatar)
        }
        
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
            let firstLetterIndex = String(friend.firstName.first!)
            if friendsDict[firstLetterIndex] != nil {
                friendsDict[firstLetterIndex]!.append(friend)
            } else {
                friendsDict[firstLetterIndex] = [friend]
            }
        }
        friendsSectionTitle = friendsDict.keys.sorted(by: { $0 < $1 })
    }
    
}

// MARK: - расширение для класса FriedsListController, реализация поиска

extension FriendsListController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterForSearchedText(searchController.searchBar.text!)
    }

    func filterForSearchedText(_ searchText: String) {
        filtredFriends = friendsList.filter({ (friend: User) -> Bool in
            let name = "\(friend.firstName) \(friend.lastName)"
            return name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}
