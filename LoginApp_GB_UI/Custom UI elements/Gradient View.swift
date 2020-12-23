//
//  Gradient View.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 23.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    @IBInspectable var startColor: UIColor = .white {
        didSet { self.updateColors() }
    }
    @IBInspectable var endColor: UIColor = .black {
        didSet { self.updateColors() }
    }
    
    @IBInspectable var startLocation: CGFloat = 0 {
        didSet { self.updateLocations() }
    }
    @IBInspectable var endLocation: CGFloat = 1 {
        didSet { self.updateLocations() }
    }
    
    @IBInspectable var startPoint: CGPoint = .zero {
        didSet { self.updateStartPoint() }
    }
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet { self.updateEndPoint() }
    }
    
    func updateLocations() {
        self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
    }
    
    func updateColors() {
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
    
    func updateStartPoint() {
        self.gradientLayer.startPoint = startPoint
    }
    
    func updateEndPoint() {
        self.gradientLayer.endPoint = endPoint
    }
    
    func setupGradient(startColor: UIColor, endColor: UIColor, startLocation: CGFloat, endLocation: CGFloat, startPoint: CGPoint, endPoint: CGPoint) {
        self.startColor = startColor
        self.endColor = endColor
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
