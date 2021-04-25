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
    func showTextButtonPressed(postId: Int, isOpened: Bool )
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
    private var postId = 0
    private var cachedTextHeight: CGFloat?
   
    @IBAction func showTextAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            openText()
        } else {
            shrinkText()
        }
    }
    
    private func openText() {
        if cachedTextHeight == nil {
            cachedTextHeight = self.getRowHeightFromText(strText: self.postTextLabel.text ?? "")
        }
        self.postTextHeightConstraint.constant = cachedTextHeight!
        
        layoutIfNeeded()
        showTextButton.setTitle("ShowLess", for: .normal)
        showTextButton.tag = 1
        delegate?.showTextButtonPressed(postId: postId, isOpened: true)
    }
    
    private func shrinkText() {
        if cachedTextHeight == nil {
            cachedTextHeight = self.getRowHeightFromText(strText: self.postTextLabel.text ?? "")
        }
        if cachedTextHeight! <= 200 {
            self.postTextHeightConstraint.constant = cachedTextHeight!
            showTextButton.isHidden = true
        } else {
            if self.postTextHeightConstraint.constant == 200,
               showTextButton.tag == 0 {
                return
            }
            self.postTextHeightConstraint.constant = 200
            showTextButton.isHidden = false
        }
        layoutIfNeeded()
        showTextButton.setTitle("ShowMore", for: .normal)
        showTextButton.tag = 0
        delegate?.showTextButtonPressed(postId: postId, isOpened: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizer(likeImage)
        setupGestureRecognizer(commentImage)
        setupGestureRecognizer(shareImage)

    }
    
    func getRowHeightFromText(strText: String!) -> CGFloat {
        
        let textSize = (strText as NSString).boundingRect(with: CGSize(width: postTextLabel.bounds.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font : postTextLabel.font!], context: nil)
        
        return ceil(textSize.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // Конфигурация ячейки
    func configure(_ post: NewsfeedPost, isOpened: Bool) {
        self.postId = post.postId
        self.likes = post.likes
        self.likeLabel.text = String(self.likes)
        
        self.comments = post.comments
        self.commentLabel.text = String(self.comments)
        
        self.shares = post.reposts
        self.shareLabel.text = String(self.shares)
        
        self.viewsLabel.text = String(post.views ?? 0)
        self.postTextLabel.text = post.text
        self.cachedTextHeight = self.getRowHeightFromText(strText: self.postTextLabel.text ?? "")
        
        authorNameLabel.text = post.authorName
        guard let url = URL(string: post.avatar) else { return }
        authorAvatarImage.kf.setImage(with: url)
        
        if isOpened {
            openText()
        } else if !isOpened {
            shrinkText()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cachedTextHeight = self.getRowHeightFromText(strText: self.postTextLabel.text ?? "")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorAvatarImage.image = nil
        cachedTextHeight = nil
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
