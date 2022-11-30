//
//  UrlTransform.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import ObjectMapper

class URLTransform: TransformType {

    typealias Object = URL
    typealias JSON = String

    func transformFromJSON(_ value: Any?) -> URL? {
        if let str = value as? String {
            return URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        return nil
    }

    func transformToJSON(_ url: URL?) -> String? {
        return url?.absoluteString
    }
}
