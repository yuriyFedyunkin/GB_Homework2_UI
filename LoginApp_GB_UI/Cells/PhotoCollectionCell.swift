//
//  PhotoCollectionCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    
    var likes = 0
    var isLiked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeImageView.image = UIImage(named: "notLiked")
        setupGestureRecognizer(likeImageView)
    }
    
    // Конфигурация ячейки с фото
    func configure(withPhoto photo: Photo) {
        likes = photo.likes
        likeLabel.text = String(likes)
        
        guard let url = URL(string: photo.url) else { return }
        friendPhoto.kf.setImage(with: url)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendPhoto.kf.cancelDownloadTask()
        friendPhoto.image = nil
    }

    
    // Логика нажатия кнопки "Like"
    func setupGestureRecognizer(_ localSender: UIImageView) {
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(likeAction(sender:)))
        localSender.isUserInteractionEnabled = true
        gestureTap.numberOfTapsRequired = 1
        localSender.addGestureRecognizer(gestureTap)
    }
    
    @objc func likeAction(sender: UIImageView) {
        if !isLiked {
            likes += 1
            isLiked = true
            likeLabel.text = String(likes)
            UIView.transition(with: likeImageView,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.likeImageView.image = UIImage(named: "liked")
            })
            
        } else {
            likes -= 1
            isLiked = false
            likeLabel.text = String(likes)
            UIView.transition(with: likeImageView,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.likeImageView.image = UIImage(named: "notLiked")
            })
        }
    }
    
}
