//
//  NSObject+Extensions.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return String(describing: self)
    }
}
