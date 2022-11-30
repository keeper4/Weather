//
//  ProfileNavigationController.swift
//  Littlebird
//
//  Created by Oleksandr Chyzh on 01.09.2022.
//  Copyright © 2022 NFC. All rights reserved.
//

import UIKit

extension UINavigationController {

    class func profileNavigationController() -> BaseNavigationController {
        let navigationController = ProfileNavigationController(
            navigationBarClass: ProfileNavigationBar.self, toolbarClass: nil)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}

class ProfileNavigationController: BaseNavigationController {

    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private var prevoiusProgressViewStatusBarStyle: UIStatusBarStyle!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prevoiusProgressViewStatusBarStyle = GIFHUD.config.preferredStatusBarStyle
        GIFHUD.config.preferredStatusBarStyle = self.preferredStatusBarStyle
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GIFHUD.config.preferredStatusBarStyle = self.prevoiusProgressViewStatusBarStyle
    }
}

class ProfileNavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        
        self.tintColor = .white
        self.barTintColor = .white
        self.titleTextAttributes = [.font : UIFont.regular(size: 14), .foregroundColor : UIColor.white]
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

