//
//  File.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

class FadeViewControllerTransitioner: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return FadeViewControllerAnimator(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeViewControllerAnimator(presenting: false)
    }
}

private class FadeViewControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting: Bool
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return .animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presenting {
            if let toView = transitionContext.view(forKey: .to) {
                
                transitionContext.containerView.addSubview(toView)
                toView.frame = transitionContext.containerView.bounds
                toView.alpha = 0.0
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                               delay: 0.0,
                               options: UIView.AnimationOptions.curveEaseOut,
                               animations: { [unowned toView] in
                                    toView.alpha = 1.0
                    }, completion: { [unowned transitionContext] finished in
                        transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
                })
            }
        } else {
            if let fromView = transitionContext.view(forKey: .from) {
                let toView = transitionContext.view(forKey: .to)
                
                if let snapshot = toView?.snapshotView(afterScreenUpdates: true) {
                    transitionContext.containerView.insertSubview(snapshot, at: 0)
                }
                
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                               delay: 0.0,
                               options: UIView.AnimationOptions.curveEaseOut,
                               animations: { [unowned fromView] in
                                    fromView.alpha = 0.0
                    }, completion: { [unowned transitionContext] finished in
                        transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
                })
            }
        }
    }
}
