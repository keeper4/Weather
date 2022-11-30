//
//  UrlHandler.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

protocol UrlHandler: AnyObject {
    
    func canHandleUrl(_ url: URL) -> Bool
    
    func handle(_ url: URL)
}

class UrlHandlerWeakBox {
    
    private(set) weak var handler: UrlHandler?
    
    init(handler: UrlHandler) {
        self.handler = handler
    }
}

final class WeakRef<T> where T: AnyObject {
    
    private(set) weak var value: T?
    
    init(value: T?) {
        self.value = value
    }
}
