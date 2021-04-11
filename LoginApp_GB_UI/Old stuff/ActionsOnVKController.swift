//
//  ActionsOnVKController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 31.01.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class ActionsOnVKController: UIViewController {

    @IBOutlet weak var searchGroupTF: UITextField!
    
    let getGroupsByRequest = GetGroupsByRequestVK()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(recognizer)
        
        searchGroupTF.delegate = self
    }
    
    @IBAction func getFriendsPressed(_ sender: Any) {
        GetFriendsVK.sendRequest()
    }
    
    @IBAction func getPhotosPressed(_ sender: Any) {
        GetPhotosVK.sendRequest()
    }
    
    @IBAction func getGroupsPressed(_ sender: Any) {
        GetGroupsVK.sendRequest()
    }
    
    @IBAction func serachGroupByRequest(_ sender: Any) {
        searchButtonPressed()
    }
    
    
    private func searchButtonPressed() {
        guard let text = searchGroupTF.text else { return }
        
        if searchGroupTF.text != "" {
            getGroupsByRequest.searchGroup(query: text)
        } else {
            showSearchErrorMessage()
        }
    }
    
    // скрытие клавиатуры по нажатию на экран
    @objc func tap() {
        searchGroupTF.resignFirstResponder()
    }
    

}

// Работа поиска по нажатию "return" на клавиатуре
extension ActionsOnVKController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonPressed()
        textField.resignFirstResponder()
        return true
    }
}

// Alert при поиске групп через VK API
extension ActionsOnVKController {
    
    func showSearchErrorMessage() {
        let alert = UIAlertController(title: "Ошибка", message: "Введите данные для поиска", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
