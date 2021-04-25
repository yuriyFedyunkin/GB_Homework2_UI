//
//  FriendCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 11.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel! {
        didSet {
            friendName.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // к даннаому view подключен class ShadowView для настройки в interface builder
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.cornerRadius = self.shadowView.frame.width / 2
            shadowView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    // автарка с эффектом загругления
    @IBOutlet weak var friendIcon: UIImageView! {
        didSet {
            friendIcon.clipsToBounds = true
            friendIcon.layer.cornerRadius = friendIcon.frame.width / 2
            friendIcon.layer.borderWidth = 1.0
            friendIcon.layer.borderColor = UIColor.lightGray.cgColor
            friendIcon.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    let insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    override var intrinsicContentSize: CGSize {
        return getCellSize(maxWidth: .greatestFiniteMagnitude)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        return getCellSize(maxWidth: size.width)
    }
    
    private func friendIconViewSize() -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    private func getCellSize(maxWidth: CGFloat) -> CGSize {
        let iconSize = friendIconViewSize()
        let nameLabelSize = getNameLabelSize(text: friendName.text!, font: friendName.font!, maxWidth: maxWidth)
        let totalWidth = nameLabelSize.width + iconSize.width + insets.left + insets.right
        let totalHeigth = iconSize.height + insets.top + insets.bottom
        let totalSize = CGSize(width: totalWidth, height: totalHeigth)
        
        return totalSize
    }
    
    func getNameLabelSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let maxWidth = maxWidth - insets.right - insets.left - friendIcon.frame.maxX
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size =  CGSize(width: ceil(width), height: ceil(height))

        return size
    }
    
    private func layoutShadowAndIconView() {
        let iconAndshadowSize = friendIconViewSize()
        let shadowOrigin = CGPoint(x: insets.left, y: insets.top)
        shadowView.frame = CGRect(origin: shadowOrigin, size: iconAndshadowSize)
        
        let iconOrigin = CGPoint(x: 0, y: 0)
        friendIcon.frame = CGRect(origin: iconOrigin, size: iconAndshadowSize)
        
    }
    
    private func layoutNameLabel() {
        let nameLabelSize = getNameLabelSize(text: friendName.text!, font: friendName.font!, maxWidth: bounds.width)
        let nameLabelOrigin = CGPoint(
            x: insets.left + shadowView.frame.maxX,
            y: insets.top + nameLabelSize.height/2)
        friendName.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutShadowAndIconView()
        layoutNameLabel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.addSubview(friendIcon)
        setupGestureRecognizer(friendIcon)
    }
    
    // Функция конфигурации ячейки пользователя из списка друзей
    func configure(withUser user: User) {
        friendName.text = user.firstName + " " + user.lastName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendIcon.image = nil
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
