//
//  NewsCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 23.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsText: UILabel!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    
    var likes = 0
    var isLiked = false
    
    var comments = 0
    var shares = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradient = GradientView()
        gradient.setupGradient(startColor: .blue, endColor: .systemGray, startLocation: 0, endLocation: 1, startPoint: .zero, endPoint: CGPoint(x:1, y: 0))
        gradient.alpha = 0.6
        self.backgroundView = gradient
        
        likeLabel.text = String(likes)
        likeImage.image = UIImage(named: "notLiked")
        
        commentLabel.text = String(comments)
        shareLabel.text = String(shares)
        
        setupGestureRecognizer(likeImage)
        setupGestureRecognizer(commentImage)
        setupGestureRecognizer(shareImage)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupGestureRecognizer(_ localSender: UIImageView) {
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        localSender.isUserInteractionEnabled = true
        gestureTap.numberOfTapsRequired = 1
        localSender.addGestureRecognizer(gestureTap)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        switch sender.view {
        case likeImage:
            if !isLiked {
                likes += 1
                isLiked = true
                likeImage.image = UIImage(named: "liked")
                likeLabel.text = String(likes)
            } else {
                likes -= 1
                isLiked = false
                likeImage.image = UIImage(named: "notLiked")
                likeLabel.text = String(likes)
            }
        case commentImage:
            comments += 1
            commentLabel.text = String(comments)
            
        case shareImage:
            shares += 1
            shareLabel.text = String(shares)
            
        default:
            return
        }
        
    }
    
}
