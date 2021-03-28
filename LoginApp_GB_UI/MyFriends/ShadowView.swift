//
//  ShadowView.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 15.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

// Эффект тени, настраиваемый через interface builder
@IBDesignable class ShadowView: UIView {

    @IBInspectable var shadowColor: UIColor = .black {
        didSet{
            layer.shadowColor =  shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float  = 1.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity/10
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 12 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
}
