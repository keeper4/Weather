//
//  Realm+Extensions.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RealmSwift

extension Realm {
    
    func writeOpeningTransactionIfNeeded(_ block: (() throws -> Void)) throws {
        if self.isInWriteTransaction {
            try block()
        } else {
            try self.write(block)
        }
    }
}
