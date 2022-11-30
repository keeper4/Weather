//
//  UserType.swift
//  digitalmedia
//
//  Created by Artem Kirnos on 4/1/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import Foundation

import ObjectMapper

enum UserType: String {
    case none
    case fan
    case celebrity

    static var transformer: TransformOf<UserType, String> {
        return TransformOf<UserType, String>(fromJSON: {
            UserType(rawValue: $0 ?? "")
        }, toJSON: {
            $0.map { String($0.rawValue) }
        })
    }

    var description: String {
        return self.rawValue
    }
}
