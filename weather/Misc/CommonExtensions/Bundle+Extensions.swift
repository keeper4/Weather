//
//  Bundle+Extensions.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

extension Bundle {
    
    func hasStoryboardNamed(_ name: String) -> Bool {
        return self.path(forResource: name, ofType: "storyboardc") != nil
    }
}
