//
//  Mapper+BaseModelStorage.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import ObjectMapper

extension Mapper where N: BaseModel {

    class func baseModel(from JSONObject: Any, context: BaseModelMappingContext) -> N? {
        if let json = JSONObject as? [String : Any] {
            if let id = json["id"] as? Int {
                if let model = context.baseModelStorage.model(ofType: N.self, for: id) {
                    model.update(with: json, context: context)
                    return model
                } else if let model = Mapper<N>(context: context).map(JSON: json) {
                    context.baseModelStorage.store(model, for: id)
                    return model
                }
                return nil
            } else if let model = Mapper<N>(context: context).map(JSON: json) {
                return model
            }
            return nil
        }
        return nil
    }

    class func baseModels(from JSONObject: Any, context: BaseModelMappingContext) -> [N]? {
        if let jsons = JSONObject as? [[String : Any]] {
            return jsons.compactMap { json in
                if let id = json["id"] as? Int {
                    if let model = context.baseModelStorage.model(ofType: N.self, for: id) {
                        model.update(with: json, context: context)
                        return model
                    } else if let model = Mapper<N>(context: context).map(JSON: json) {
                        context.baseModelStorage.store(model, for: id)
                        return model
                    }
                    return nil
                } else if let model = Mapper<N>(context: context).map(JSON: json) {
                    return model
                }
                return nil
            }
        }
        return nil
    }
}
