//
//  VerificationStatus.swift
//  digitalmedia
//
//  Created by Artem Kirnos on 3/4/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import UIKit

import ObjectMapper

enum VerificationStatus: String {
    case none
    case incomplete
    case inProgress
    case verified
    case rejected
    
    static var transformer: TransformOf<VerificationStatus, String> {
        return TransformOf<VerificationStatus, String>(fromJSON: {
            VerificationStatus(rawValue: $0 ?? "")
        }, toJSON: {
            $0.map { String($0.rawValue) }
        })
    }
}
