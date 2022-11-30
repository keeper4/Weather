//
//  CGPoint+Extensions.swift
//  digitalmedia
//
//  Created by Rasul on 29/3/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import UIKit

extension CGPoint {

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
