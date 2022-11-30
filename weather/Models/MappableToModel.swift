//
//  MappableToModel.swift
//  digitalmedia
//
//  Created by Rasul on 13/12/18.
//  Copyright © 2018 Zensoft. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

protocol MappableToModel: Mappable {
    
    associatedtype Model: BaseMappable
}

extension MappableToModel where Self: Object {
    
    func toModel() -> Model {
        let json = self.toJSON()
        return Model(JSON: json)!
    }
}
