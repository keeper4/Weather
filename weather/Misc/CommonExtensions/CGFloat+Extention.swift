//
//  CGFloat+Extention.swift
//  digitalmedia
//
//  Created by Artem Kirnos on 6/11/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import UIKit

extension CGFloat {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
