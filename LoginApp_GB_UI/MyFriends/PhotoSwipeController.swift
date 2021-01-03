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

        setupLeftSwipeAction(view)
        setupRightSwipeAction(view)
    
    }
    
    func setupLeftSwipeAction(_ sender: UIView) {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        leftSwipe.direction = .left
        sender.addGestureRecognizer(leftSwipe)
    }
    
    func setupRightSwipeAction(_ sender: UIView) {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        rightSwipe.direction = .right
        sender.addGestureRecognizer(rightSwipe)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else { return }
        
        switch swipeGesture.direction {
        case .left:
            if currentImage == photoLibrary.count - 1 {
                currentImage = 0
            } else {
                currentImage += 1
            }
            displayedImage.image = photoLibrary[currentImage]
            
        case .right:
            if currentImage == 0 {
                currentImage = photoLibrary.count - 1
            } else {
                currentImage -= 1
            }
            displayedImage.image = photoLibrary[currentImage]
            
        default:
            break
        }
        
    }
 
}
