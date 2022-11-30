//
//  ViewControllerFromStoryboard.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

protocol ViewControllerFromStoryboard {}

extension ViewControllerFromStoryboard where Self: UIViewController {

    static func viewControllerFromStoryboard() -> Self {
        func viewControllerNamed(_ name: String, from bundle: Bundle) -> Self {
            let storyboard = UIStoryboard(name: name, bundle: bundle)
            guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
                fatalError("cannot instantiate view controller")
            }
            return viewController
        }

        let className = NSStringFromClass(self)
        let strippedClassName = className.components(separatedBy: ".").last ?? className

        if Bundle.main.hasStoryboardNamed(strippedClassName) {
            return viewControllerNamed(strippedClassName, from: Bundle.main)
        } else {
            fatalError("no view controller storyboard found")
        }
    }
}
