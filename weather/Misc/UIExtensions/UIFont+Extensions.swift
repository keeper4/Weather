//
//  UIFont+Extensions.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

extension UIFont {

    static func regular(size: CGFloat) -> UIFont {
        return self.systemFont(ofSize: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return self.boldSystemFont(ofSize: size)
    }
}
