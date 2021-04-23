//
//  PostFeedCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 21.03.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import UIKit
import Kingfisher

protocol PostFeedCellDelegate: AnyObject {
    func showTextButtonPressed()
}

class PostFeedCell: UITableViewCell {
    
    weak var delegate: PostFeedCellDelegate?

    @IBOutlet weak var authorAvatarImage: UIImageView! {
        didSet {
            self.authorAvatarImage.clipsToBounds = true
            self.authorAvatarImage.layer.cornerRadius = self.authorAvatarImage.frame.width / 2
            self.authorAvatarImage.layer.borderWidth = 1.0
            self.authorAvatarImage.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var viewsLabel: UILabel!
    
    
    @IBOutlet weak var postTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showTextButton: UIButton!{
        didSet{
            showTextButton.setTitle("Show more...", for: .normal)
        }
    }
    
    private var isLiked = false
    private var likes = 0
    private var comments = 0
    private var shares = 0
   
    @IBAction func showTextAction(_ sender: UIButton) {
        delegate?.showTextButtonPressed()
        
        if sender.tag == 0 {
            let height = self.getRowHeightFromText(strText: self.postTextLabel.text ?? "")
            self.postTextHeightConstraint.constant = height
            
            layoutIfNeeded()
            showTextButton.setTitle("ShowLess", for: .normal)
            sender.tag = 1
            
        } else {
            self.postTextHeightConstraint.constant = 200
            layoutIfNeeded()
            showTextButton.setTitle("ShowMore", for: .normal)
            sender.tag = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizer(likeImage)
        setupGestureRecognizer(commentImage)
        setupGestureRecognizer(shareImage)

    }
    
    func getRowHeightFromText(strText: String!) -> CGFloat {
        let txtLabel: UILabel = UILabel(frame: CGRect(x: self.postTextLabel.frame.origin.x,
                                                       y: 0,
                                                       width: self.postTextLabel.frame.size.width,
                                                       height: 0))
        txtLabel.text = strText
        txtLabel.numberOfLines = 0
        txtLabel.sizeToFit()
        
        var txtFrame: CGRect = CGRect()
        txtFrame = txtLabel.frame
        
        var size: CGSize = CGSize()
        size = txtFrame.size
        size.height = txtFrame.size.height
        
        return size.height
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
        
        self.viewsLabel.text = String(post.views ?? 0)
        self.postTextLabel.text = post.text
        
        authorNameLabel.text = post.authorName
        guard let url = URL(string: post.avatar) else { return }
        authorAvatarImage.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorAvatarImage.image = nil
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
