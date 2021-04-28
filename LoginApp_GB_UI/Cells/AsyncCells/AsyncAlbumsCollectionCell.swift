//
//  AsyncAlbumsCollectionCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 27.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import AsyncDisplayKit

class AsyncAlbumsCollectionCell: ASCellNode {

    private let cover: UIImage
    private let photosCount: Int
    private let title: String
    
    private let coverNode = ASImageNode()
    private let photosCountNode = ASTextNode()
    private let titleNode = ASTextNode()
    
    init(cover: UIImage, photosCount: Int, title: String) {
        self.cover = cover
        self.photosCount = photosCount
        self.title = title
        super.init()
        setupSubnodes()
    }
    
    func setupSubnodes() {
        coverNode.image = cover
        coverNode.contentMode = .scaleAspectFill
        addSubnode(coverNode)
        
        photosCountNode.attributedText = NSAttributedString(string: String(photosCount) + " фото",
                                                            attributes: [.font: UIFont.italicSystemFont(ofSize: 14),
                                                                         .foregroundColor: UIColor.lightGray])
        photosCountNode.backgroundColor = .clear
        photosCountNode.maximumNumberOfLines = 1
        addSubnode(photosCountNode)
        
        titleNode.attributedText = NSAttributedString(string: String(title),
                                                      attributes: [.font: UIFont.systemFont(ofSize: 17)])
        titleNode.backgroundColor = .clear
        titleNode.maximumNumberOfLines = 2
        addSubnode(titleNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        coverNode.style.preferredSize = CGSize(width: 130, height: 120)
        titleNode.style.width = coverNode.style.width

        let verticalStackSpec = ASStackLayoutSpec()
        verticalStackSpec.direction = .vertical
        verticalStackSpec.children = [coverNode, titleNode, photosCountNode]
        verticalStackSpec.spacing = 3
        
        let specWithInsets = ASInsetLayoutSpec(insets: insets, child: verticalStackSpec)
        
        return specWithInsets
    }
}
