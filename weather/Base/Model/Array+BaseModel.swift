//
//  Array+BaseModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import ObjectMapper

extension Array where Element: BaseModel {

    mutating func update(with JSONs: [[String : Any]], context: BaseModelMappingContext) {
        var updatedElements = [Element]()
        for (index, json) in JSONs.enumerated() {
            if index < self.count {
                let oldObject = self[index]
                oldObject.update(with: json, context: context)
                updatedElements.append(oldObject)
            } else {
                if let object = Mapper<Element>().map(JSON: json) {
                    updatedElements.append(object)
                }
            }
        }
        self = updatedElements
    }
}

extension Array where Element: BaseIdModel {

    mutating func update(with JSONs: [[String : Any]], context: BaseModelMappingContext) {
        var updatedElements = [Element]()
        for json in JSONs {
            if let id = json["id"] as? Int {
                if let model = context.baseModelStorage.model(ofType: Element.self, for: id) {
                    model.update(with: json, context: context)
                    updatedElements.append(model)
                } else if let model = Mapper<Element>.baseModel(from: json, context: context) {
                    updatedElements.append(model)
                }
            }
        }
        self = updatedElements
    }
}
