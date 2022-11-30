//
//  ObservableType+Extensions.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {

    func doOnNextAndOnError(_ action: @escaping () -> Void) -> Observable<Self.Element> {
        return self.do(
            onNext: { _ in
                action()
            },
            onError: { _ in
                action()
            }
        )
    }
    
    func doOnNext(_ action: @escaping (Self.Element) -> Void) -> Observable<Self.Element> {
        return self.do(onNext: { action($0) })
    }
    
    func doOnError(_ action: @escaping (Swift.Error) -> Void) -> Observable<Self.Element> {
        return self.do(onError: { action($0) })
    }
}

extension SharedSequenceConvertibleType {
    func doOnNext(_ action: @escaping (Self.Element) -> Void) -> SharedSequence<SharingStrategy, Self.Element> {
        return self.do(onNext: { action($0) })
    }
}
