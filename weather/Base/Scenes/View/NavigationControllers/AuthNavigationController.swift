//
//  AuthNavigationController.swift
//  digitalmedia
//
//  Created by Rasul on 6/3/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    class func authNavigationController() -> BaseNavigationController {
        let navigationController = AuthNavigationController(
            navigationBarClass: AuthNavigationControllerNavigationBar.self, toolbarClass: nil)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}

class AuthNavigationController: BaseNavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class AuthNavigationControllerNavigationBar: UINavigationBar {
    
    //    private let imageContainerView = UIView()
    //
    //    var isBackgroundImageViewHidden: Bool {
    //        get { return self.imageContainerView.isHidden }
    //        set { self.imageContainerView.isHidden = newValue }
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension AuthNavigationController {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        switch operation {
        case .push:
            return FadeNavigationControllerAnimator(pushing: true)
            
        case .pop:
            return FadeNavigationControllerAnimator(pushing: false)
            
        default:
            return nil
        }
    }
}
