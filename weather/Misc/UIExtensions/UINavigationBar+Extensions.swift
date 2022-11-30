//
//  UINavigationBar+Extensions.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setGradientBackground(colors: [UIColor],
                               startPoint: CAGradientLayer.Point = .right,
                               endPoint: CAGradientLayer.Point = .left) {
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame,
                                            colors: colors,
                                            startPoint: startPoint,
                                            endPoint: endPoint)
        setBackgroundImage(gradientLayer.createGradientImage(), for: .default)
    }
}
