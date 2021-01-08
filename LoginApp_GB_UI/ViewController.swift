//
//  ViewController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 02.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 18
        
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }

    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var indicator1: LoadingIndicatorView!
    @IBOutlet weak var indicator2: LoadingIndicatorView!
    @IBOutlet weak var indicator3: LoadingIndicatorView!
    
   
    //MARK: - Индмкатор загрузки
    
    override func viewDidAppear(_ animated: Bool) {
        
        let indicatorsArray = [indicator1, indicator2, indicator3]
        var delay: TimeInterval = 0
        
        for loadIndicator in indicatorsArray {
            if let indicator = loadIndicator {
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               options: [.repeat, .autoreverse],
                               animations: {
                                self.opacityLoadIndicator(indicator, delay: delay)
                })
            }
            delay += 0.2
        }
        delay = 0
    }
    
    private func opacityLoadIndicator(_ sender: UIView, delay: TimeInterval){
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.beginTime = CACurrentMediaTime() + delay
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        sender.layer.add(animation, forKey: nil)
        

    }
    
    
    
  //MARK: - Keyboard settings
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    
    // MARK: - Login data check and alert controller
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
       // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   

    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }

  
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        passwordInput.text = nil
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let checkResult = checkLoginData()
        
        if !checkLoginData() {
            showLoginError()
        }
        return checkResult
    }
    
    func checkLoginData() -> Bool {
        guard let login = loginInput.text, let password = passwordInput.text else { return false }
        
        if login == "" && password == "" {
            return true
        } else {
            return false
        }
    }
    
    func showLoginError() {
        let alert = UIAlertController(title: "Error", message: "Incorrect login or password", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}



