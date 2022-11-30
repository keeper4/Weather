//
//  HTTPRequestManager.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import RxCocoa
import RxSwift

protocol PreRequestActor {
    
    func shouldBeExecuted() -> Bool
    
    func execute() -> Observable<Void>
}

protocol ErrorResolver {
    
    func resolve(_ error: Error) -> Observable<Void>
}

class HTTPRequestManager: BaseDataManager {
    
    private var baseUrl:    URL
    private var session:    URLSession
    
    var preRequestActors    = [PreRequestActor]()
    var errorResolvers      = [ErrorResolver]()
    
    let disposeBag = DisposeBag()
    
    init(baseModelStorage: BaseModelStorage,
         baseUrlString: String) throws
    {
        guard let baseUrl = URL(string: baseUrlString) else {
            throw NetworkError.invalidUrl
        }
        
        self.baseUrl    = baseUrl
        self.session    = type(of: self).createSession()
        
        super.init(baseModelStorage: baseModelStorage)
    }
    
    private static func createSession() -> URLSession {
        let configuration                                       = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders                     = [:]
        configuration.httpAdditionalHeaders?["Content-Type"]    = "application/json"
        configuration.requestCachePolicy                        = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }
    
    func makeRequest(_ httpRequest: HTTPRequest, timeoutInterval: Double? = nil) -> Observable<Void> {
        return self.makeSimpleRequest(httpRequest, timeoutInterval: timeoutInterval)
            .retry(when: self.executeErrorResolvers)
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func makeRequest<T: BaseModel>(_ httpRequest: HTTPRequest, timeoutInterval: Double? = nil) -> Observable<T> {
        return self.makeSimpleRequest(httpRequest, timeoutInterval: timeoutInterval)
            .retry(when: self.executeErrorResolvers)
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func makeRequest<T: BaseModel>(_ httpRequest: HTTPRequest, timeoutInterval: Double? = nil) -> Observable<[T]> {
        return self.makeSimpleRequest(httpRequest, timeoutInterval: timeoutInterval)
            .retry(when: self.executeErrorResolvers)
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func makeSimpleRequest(_ httpRequest: HTTPRequest, timeoutInterval: Double?) -> Observable<Void> {
        let headers = self.session.configuration.httpAdditionalHeaders ?? [:]
#if DEBUG
        print("\nHeaders: \(headers)\nHTTPRequest: \(httpRequest.description)\n")
#endif
        return Observable.just(())
            .map { try httpRequest.request(with: self.baseUrl, timeoutInterval: timeoutInterval) }
            .flatMapLatest { [unowned self] in self.session.rx.json(request: $0) }
            .map { _ in }
            .catch(self.parseError)
                    .observe(on:MainScheduler.instance)
    }
    
    func makeSimpleRequest<T: BaseModel>(_ httpRequest: HTTPRequest, timeoutInterval: Double?) -> Observable<T> {
        let headers = self.session.configuration.httpAdditionalHeaders ?? [:]
#if DEBUG
        print("\nHeaders: \(headers)\nHTTPRequest: \(httpRequest.description)\n")
#endif
        let result = Observable.just(())
            .map { try httpRequest.request(with: self.baseUrl, timeoutInterval: timeoutInterval) }
            .flatMapLatest { [unowned self] in self.session.rx.json(request: $0) }
            .map { [weak self] response -> T? in
                guard let self = self else { return nil }
                return Mapper<T>.baseModel(from: response, context: self)
            }
            .observe(on:MainScheduler.instance)
            .share()
        
        let success = result
            .filter { $0 != nil }
            .map { $0! }
            .catch(self.parseError)
                    
                    let error = result
                    .filter { $0 == nil }
            .flatMapLatest { _ in
                return Observable<T>.error(NetworkError.cantParseModel)
            }
            .catch(self.parseError)
                    
                    return Observable.merge(success, error)
    }
    
    func makeSimpleRequest<T: BaseModel>(_ httpRequest: HTTPRequest, timeoutInterval: Double?) -> Observable<[T]> {
        let headers = self.session.configuration.httpAdditionalHeaders ?? [:]
#if DEBUG
        print("\nHeaders: \(headers)\nHTTPRequest: \(httpRequest.description)\n")
#endif
        return Observable.just(())
            .map { try httpRequest.request(with: self.baseUrl, timeoutInterval: timeoutInterval) }
            .flatMapLatest { [unowned self] in self.session.rx.json(request: $0) }
            .map { [weak self] response -> [T] in
                guard let self = self else { return [] }
                return Mapper<T>.baseModels(from: response, context: self) ?? []
            }
            .catch(self.parseError)
                    .observe(on:MainScheduler.instance)
    }
    
    private func executeErrorResolvers(_ errorObservable: Observable<Error>) -> Observable<Void> {
        return errorObservable
            .observe(on: SerialDispatchQueueScheduler(queue: DispatchQueue.global(),
                                                      internalSerialQueueName: "executeErrorResolvers"))
            .flatMapLatest { error -> Observable<Void> in
                throw error
            }
    }
    
    private func parseError(_ error: Error) throws -> Observable<Void> {
        let error = NetworkError(error: error)
        switch error {
        case .noResponse:
            return Observable.just(())
            
        default:
            throw error
        }
    }
    
    private func parseError<T: BaseModel>(_ error: Error) throws -> Observable<T> {
        throw NetworkError(error: error)
    }
    
    private func parseError<T: BaseModel>(_ error: Error) throws -> Observable<[T]> {
        throw NetworkError(error: error)
    }
}

extension HTTPRequestManager: BaseModelMappingContext {}

enum HTTPRequestMethod: String {
    case GET, POST, PATCH, PUT, DELETE, MULTIPART_POST, MULTIPART_PATCH
    
    var description: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .PATCH:
            return "PATCH"
        case .PUT:
            return "PUT"
        case .DELETE:
            return "DELETE"
        case .MULTIPART_POST:
            return "POST"
        case .MULTIPART_PATCH:
            return "PATCH"
        }
    }
}

protocol HTTPRequest {
    var method:     HTTPRequestMethod   { get }
    var path:       String              { get }
    var parameters: [String: Any]?      { get }
}

extension HTTPRequest {
    
    var description: String {
        return "-\(method) path: \(path) parameters: \(parameters ?? [:])"
    }
    
    func request(with baseURL: URL, timeoutInterval: Double? = nil) throws -> URLRequest {
        guard
            var components = URLComponents(url: baseURL.appendingPathComponent(self.path),
                                           resolvingAgainstBaseURL: false)
        else { throw NetworkError.invalidUrl }
        
        var httpBody: NSMutableData?
        var boundary = ""
        
        switch self.method {
        case .GET:
            components.queryItems = self.parameters?.compactMap {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
            
        case .POST, .PATCH, .PUT, .DELETE:
            if let body = try? JSONSerialization.data(withJSONObject: self.parameters ?? [:], options: []) {
                httpBody = NSMutableData()
                httpBody?.append(body)
            }
            
        case .MULTIPART_POST, .MULTIPART_PATCH:
            guard let params = self.parameters else { break }
            httpBody = NSMutableData()
            
            let stringParameters = params
                .filter { $0.1 is String }
                .mapValues { $0 as! String }
            
            let imageParameters = params
                .filter { $0.1 is UIImage }
                .mapValues { $0 as! UIImage }
            
            let dataParameters = params
                .filter { $0.1 is Data }
                .mapValues { $0 as! Data }
            
            boundary = "Boundary-\(UUID().uuidString)"
            let boundaryPrefix = "--\(boundary)\r\n"
            
            for (key, value) in stringParameters {
                httpBody?.appendString(boundaryPrefix)
                httpBody?.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                if value.isEmpty, stringParameters.count > 1 {
                    httpBody?.appendString("\(value)\r\n")
                } else {
                    httpBody?.appendString("\(value)")
                }
            }
            
            if stringParameters.count > 0, imageParameters.count > 0 {
                httpBody?.appendString("\r\n")
            }
            
            for (key, value) in imageParameters {
                guard let data = value.jpegData(compressionQuality: 0.2) else {
                    break
                }
                let fileName = "\(NSUUID().uuidString).jpeg"
                
                httpBody?.appendString(boundaryPrefix)
                httpBody?.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
                httpBody?.appendString("Content-Type: image/jpeg\r\n\r\n")
                httpBody?.append(data)
                httpBody?.appendString("\r\n")
                httpBody?.appendString("--\(boundary)--\r\n")
            }
            
            for (key, value) in dataParameters {
                let fileName = "\(NSUUID().uuidString).mp4"
                
                httpBody?.appendString(boundaryPrefix)
                httpBody?.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
                httpBody?.appendString("Content-Type: video/mp4\r\n\r\n")
                httpBody?.append(value)
                httpBody?.appendString("\r\n")
                httpBody?.appendString("--\(boundary)--\r\n")
            }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidUrl
        }
        
        var request         = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval ?? Constants.timeoutInterval
        request.httpMethod  = self.method.description
        request.httpBody    = httpBody as Data?
        
        if !boundary.isEmpty {
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            append(data)
        }
    }
}
