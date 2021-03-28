//
//  PostFeedCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 21.03.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class PostFeedCell: UITableViewCell {

    @IBOutlet weak var authorAvatarImage: UIImageView! {
        didSet {
            self.authorAvatarImage.clipsToBounds = true
            self.authorAvatarImage.layer.cornerRadius = self.authorAvatarImage.frame.width / 2
            self.authorAvatarImage.layer.borderWidth = 1.0
            self.authorAvatarImage.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var viewsLabel: UILabel!
    
    private var isLiked = false
    private var likes = 0
    private var comments = 0
    private var shares = 0
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizer(likeImage)
        setupGestureRecognizer(commentImage)
        setupGestureRecognizer(shareImage)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // Конфигурация ячейки
    func configure(_ post: NewsfeedPost) {
        self.likes = post.likes
        self.likeLabel.text = String(self.likes)
        
        self.comments = post.comments
        self.commentLabel.text = String(self.comments)
        
        self.shares = post.reposts
        self.shareLabel.text = String(self.shares)
        
        self.viewsLabel.text = String(post.views)
        self.postTextView.text = post.text
        
        authorNameLabel.text = post.authorName
        guard let url = URL(string: post.avatar) else { return }
        if let data = try? Data(contentsOf: url) {
            authorAvatarImage.image = UIImage(data: data)
  
        }
    }
   
    // Конфигурация нажатия кнопок like/comment/share
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
                likeLabel.text = String(likes)
                UIView.transition(with: likeImage,
                                  duration: 0.3,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    self.likeImage.image = UIImage(named: "liked")
                })
                
            } else {
                likes -= 1
                isLiked = false
                likeLabel.text = String(likes)
                UIView.transition(with: likeImage,
                                  duration: 0.3,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    self.likeImage.image = UIImage(named: "notLiked")
                })
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
