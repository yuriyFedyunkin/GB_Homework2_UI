//
//  UserGroupCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit
import Kingfisher

class UserGroupCell: UITableViewCell {

    @IBOutlet weak var groupNameText: UILabel!
    @IBOutlet weak var groupIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizer(groupIcon)
    }
    
    // Функция конфигурации ячейки с группой
    func configure(withGroup group: Group) {
        groupNameText.text = group.name
        
        guard let url = URL(string: group.avatar) else { return }
        groupIcon.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupIcon.kf.cancelDownloadTask()
        groupIcon.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
