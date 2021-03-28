//
//  FriendCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    
    // к даннаому view подключен class ShadowView для настройки в interface builder
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            self.shadowView.layer.cornerRadius = self.shadowView.frame.width / 2
        }
    }
    // автарка с эффектом загругления
    @IBOutlet weak var friendIcon: UIImageView! {
        didSet {
            self.friendIcon.clipsToBounds = true
            self.friendIcon.layer.cornerRadius = self.friendIcon.frame.width / 2
            self.friendIcon.layer.borderWidth = 1.0
            self.friendIcon.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizer(friendIcon)
    }
    
    // Функция конфигурации ячейки пользователя из списка друзей
    func configure(withUser user: User) {
        friendName.text = user.firstName + " " + user.lastName
        
        guard let url = URL(string: user.avatar) else { return }
        if let data = try? Data(contentsOf: url) {
            friendIcon.image = UIImage(data: data)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Avatar animation
    func setupGestureRecognizer(_ localSender: UIImageView){
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        localSender.isUserInteractionEnabled = true
        gestureTap.numberOfTapsRequired = 1
        localSender.addGestureRecognizer(gestureTap)
    }
    
    @objc func avatarTapped(_ sender: UIGestureRecognizer) {
        
        if let animatedView = sender.view {
            let animation = CASpringAnimation(keyPath: "transform.scale")
            animation.duration = 0.3
            animation.fromValue = 1.0
            animation.toValue = 0.8
            animation.damping = 0.1
            animation.stiffness = 200
            animation.mass = 0.5
            animatedView.layer.add(animation, forKey: nil)
        }
    }
}
