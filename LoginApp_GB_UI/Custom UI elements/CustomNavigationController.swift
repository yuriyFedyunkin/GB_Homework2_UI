//
//  CustomNavigationController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 07.01.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        destination.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform(rotationAngle: -90)
        transitionContext.containerView.addSubview(destination.view)
        
       
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced) {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.5) {
                source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
                
                let rotation = CGAffineTransform(rotationAngle: 90)
                source.view.transform = rotation
            }
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.5) {
                                        destination.view.transform = .identity
                                    }
            
        } completion: { (finished) in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }

    }
 
}

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        destination.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
    
        destination.view.frame = source.view.frame
        
        let rotation = CGAffineTransform(rotationAngle: 90)
        destination.view.transform = rotation
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        let rotation = CGAffineTransform(rotationAngle: -90)
                                                        source.view.transform = rotation
                                                       })
                                 
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        destination.view.transform = .identity
                                                       })
            
                                }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
      
}

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    let interactiveTransition = CustomInteractiveTransition()
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        }
        return nil
    }
 
}
