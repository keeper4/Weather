//
//  NSLayoutConstraint+Extention.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func trailing(fromItem: Any, toItem: Any?, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: fromItem,
                                  attribute: .trailing,
                                  relatedBy: .equal,
                                  toItem: toItem,
                                  attribute: .trailing,
                                  multiplier: 1,
                                  constant: constant)
    }
    
    func leading(fromItem: Any, toItem: Any?, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: fromItem,
                                  attribute: .leading,
                                  relatedBy: .equal,
                                  toItem: toItem,
                                  attribute: .leading,
                                  multiplier: 1,
                                  constant: constant)
    }
    
    func bottom(fromItem: Any, toItem: Any?, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: fromItem,
                                  attribute: .bottom,
                                  relatedBy: .equal,
                                  toItem: toItem,
                                  attribute: .bottom,
                                  multiplier: 1,
                                  constant: constant)
    }
    
    func top(fromItem: Any, toItem: Any?, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: fromItem,
                                  attribute: .top,
                                  relatedBy: .equal,
                                  toItem: toItem,
                                  attribute: .top,
                                  multiplier: 1,
                                  constant: constant)
    }
    
    func height(fromItem: Any, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: fromItem,
                                  attribute: .height,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  multiplier: 1,
                                  constant: constant)
    }
}
