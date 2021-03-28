//
//  PhotoSwipeController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 02.01.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class PhotoSwipeController: UIViewController {

    var photoLibrary = [UIImage?]()
    
    var currentImage = 0
    
    @IBOutlet weak var displayedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayedImage.image = photoLibrary[currentImage]
        
        displayedImage.isUserInteractionEnabled = true
        displayedImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture)))
        
//        setupLeftSwipeAction(view)
//        setupRightSwipeAction(view)
    
    }
    
    //MARK: - Swipe and Pan Recognizer Logic
    
    @objc func respondToPanGesture(gesture: UIPanGestureRecognizer) {

        if gesture.state == .changed {
            
            let translation = gesture.translation(in: view)
            displayedImage.transform = CGAffineTransform(translationX: translation.x, y: 0)
            
        } else if gesture.state == .ended {
            
            if displayedImage.frame.maxX <= view.frame.maxX * 0.65 {
                currentImage == photoLibrary.count - 1 ? currentImage = 0 : (currentImage += 1)
                leftSwipeAnimation()
                
            } else if displayedImage.frame.minX >= view.frame.maxX * 0.35 {
                currentImage == 0 ? (currentImage = photoLibrary.count - 1) : (currentImage -= 1)
                rightSwipeAnimation()
                
            } else {
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                    self.displayedImage.transform = .identity
                }, completion: nil)
            }
        }
    }
    
//    func setupLeftSwipeAction(_ sender: UIView) {
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
//        leftSwipe.direction = .left
//        sender.addGestureRecognizer(leftSwipe)
//    }
//
//    func setupRightSwipeAction(_ sender: UIView) {
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
//        rightSwipe.direction = .right
//        sender.addGestureRecognizer(rightSwipe)
//    }
//
//    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
//        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else { return }
//
//        switch swipeGesture.direction {
//        case .left:
//            if currentImage == photoLibrary.count - 1 {
//                currentImage = 0
//            } else {
//                currentImage += 1
//            }
//            leftSwipeAnimation()
//
//        case .right:
//            if currentImage == 0 {
//                currentImage = photoLibrary.count - 1
//            } else {
//                currentImage -= 1
//            }
//            rightSwipeAnimation()
//
//        default:
//            break
//        }
//
//    }
    
    
    //MARK: - Swipe Animation Functions
    
    func leftSwipeAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.displayedImage.frame = self.displayedImage.frame.offsetBy(dx: -self.view.frame.maxX, dy: 0)
            self.displayedImage.layer.opacity = 0.0
            self.displayedImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        } completion: { _ in
            UIView.animate(withDuration: 0.01) {
                self.displayedImage.frame = self.displayedImage.frame.offsetBy(dx: +self.view.frame.maxX, dy: 0)
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.displayedImage.image = self.photoLibrary[self.currentImage]
                    self.displayedImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    self.displayedImage.layer.opacity = 1.0
                }
            }
        }
    }
    
    func rightSwipeAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.displayedImage.frame = self.displayedImage.frame.offsetBy(dx: +self.view.frame.maxX, dy: 0)
            self.displayedImage.layer.opacity = 0.0
            self.displayedImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        } completion: { _ in
            UIView.animate(withDuration: 0.01) {
                self.displayedImage.frame = self.displayedImage.frame.offsetBy(dx: -self.view.frame.maxX, dy: 0)
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.displayedImage.image = self.photoLibrary[self.currentImage]
                    self.displayedImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    self.displayedImage.layer.opacity = 1.0
                }
            }
        }
    }
    
    
}
