//
//  UIViewController+Extensions.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - UIAlertController

    class AlertAction {

        public var title: String?
        public var action: (() -> Void)?
        public var cancellingAction: Bool = false

        public init(title: String?, action: (() -> Void)? = nil, cancellingAction: Bool = false) {
            self.title = title
            self.action = action
            self.cancellingAction = cancellingAction
        }
    }

    func displayAlert(withMessage message: String?,
                      title: String?,
                      actions: [AlertAction],
                      animated: Bool,
                      style: UIAlertController.Style = .alert) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { action in
            let style = action.cancellingAction ? UIAlertAction.Style.cancel : UIAlertAction.Style.default
            let alertAction = UIAlertAction(title: action.title, style: style, handler: { _ in
                action.action?()
            })
            alertController.addAction(alertAction)
        }
        self.present(alertController, animated: animated, completion: nil)
    }
}

extension UIViewController {
    func animateWithKeyboard(
        notification: NSNotification,
        animations: ((_ keyboardFrame: CGRect) -> Void)?
    ) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
        
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!
        
        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        
        // Start the animation
        animator.startAnimation()
    }
}
