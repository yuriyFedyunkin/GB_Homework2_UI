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
            self.friendIcon.layer.borderColor = UIColor.black.cgColor

        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
