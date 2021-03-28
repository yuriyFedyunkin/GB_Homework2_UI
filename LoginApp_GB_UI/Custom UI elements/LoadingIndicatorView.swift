//
//  LoadingIndicatorView.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 30.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size.width = 25
        self.frame.size.height = 25
        
        self.layer.opacity = 0.2
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
