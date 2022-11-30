//
//  MappableToModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

protocol MappableToModel: Mappable {
    
    associatedtype Model: BaseModel
}

extension MappableToModel where Self: Object {
    
    func toModel(_ context: BaseModelMappingContext) -> Model? {
        let json = self.toJSON()
        return Mapper<Model>.baseModel(from: json, context: context)
    }
}
