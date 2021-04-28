//
//  AsyncPhotoCollectionCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 27.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import AsyncDisplayKit
import Kingfisher

class AsyncPhotoCollectionCell: ASCellNode {

    private let photo: UIImage
    private var likes: Int
    private var isLiked = false
    
    private let photoNode = ASImageNode()
    private let likeImageNode = ASImageNode()
    private let likeCountNode = ASTextNode()
    
    init(photo: UIImage, likes: Int) {
        self.photo = photo
        self.likes = likes
        super.init()
        setupSubnodes()
    }
    
    override func didLoad() {
        setupGestureRecognizer(likeImageNode.view)
    }
    
    func setupSubnodes() {
        photoNode.image = photo
        photoNode.contentMode = .scaleAspectFill
        addSubnode(photoNode)
        
        likeImageNode.image = UIImage(named: "notLiked")
        likeImageNode.contentMode = .scaleAspectFit
        addSubnode(likeImageNode)
        
        likeCountNode.attributedText = NSAttributedString(string: String(likes),
                                                          attributes: [.font: UIFont.systemFont(ofSize: 17)])
        likeCountNode.backgroundColor = .clear
        likeCountNode.maximumNumberOfLines = 1
        addSubnode(likeCountNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        photoNode.style.preferredSize = CGSize(width: 130, height: 120)
        likeImageNode.style.preferredSize = CGSize(width: 25, height: 25)

        let horizontalStackSpec = ASStackLayoutSpec()
        horizontalStackSpec.direction = .horizontal
        horizontalStackSpec.children = [likeImageNode, likeCountNode]
        horizontalStackSpec.spacing = 8
        
        let verticalStackSpec = ASStackLayoutSpec()
        verticalStackSpec.direction = .vertical
        verticalStackSpec.children = [photoNode, horizontalStackSpec]
        verticalStackSpec.spacing = 8
        
        let specWithInsets = ASInsetLayoutSpec(insets: insets, child: verticalStackSpec)
        
        return specWithInsets
    }
    
    // Логика нажатия кнопки "Like"
    func setupGestureRecognizer(_ localSender: UIView) {
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(likeAction(sender:)))
        localSender.isUserInteractionEnabled = true
        gestureTap.numberOfTapsRequired = 1
        localSender.addGestureRecognizer(gestureTap)
    }
    
    @objc func likeAction(sender: UIImageView) {
        if !isLiked {
            likes += 1
            isLiked = true
            likeCountNode.attributedText = NSAttributedString(string: String(likes),
                                                              attributes: [.font: UIFont.systemFont(ofSize: 17)])
            UIView.transition(with: likeImageNode.view,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.likeImageNode.image = UIImage(named: "liked")
                              })
            
        } else {
            likes -= 1
            isLiked = false
            likeCountNode.attributedText = NSAttributedString(string: String(likes),
                                                              attributes: [.font: UIFont.systemFont(ofSize: 17)])
            UIView.transition(with: likeImageNode.view,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.likeImageNode.image = UIImage(named: "notLiked")
            })
        }
    }
}
