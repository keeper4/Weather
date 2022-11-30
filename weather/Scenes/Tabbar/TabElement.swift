//
//  TabElement.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

enum TabElementType {
    case search
}

protocol TabElement: AnyObject {
    var tabIcon:                String                      { get }
    var tabViewController:      UINavigationController?     { get }
    var tabElementType:         TabElementType              { get }
    var itemEnable:             Bool                        { get }
}
