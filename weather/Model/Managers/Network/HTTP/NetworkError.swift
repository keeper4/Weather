//
//  NetworkError.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension NetworkError {
    
    init(error: Error) {
        
        switch error {
        case let error as NetworkError:
            self = error
            
        case let error as RxCocoaURLError:
            switch error {
            case .httpRequestFailed(let response, let data):
                var message: String?
                var subCode: Int?
                if let data = data,
                   
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    message = json["message"] as? String
                    subCode = json["code"] as? Int
                }
                
                let statusCode = response.statusCode
                let urlString = response.url?.absoluteString ?? ""
                
                self = Self.parseGenericError(statusCode: statusCode,
                                              urlString: urlString,
                                              message: message,
                                              subCode: subCode)
                
            case .deserializationError(let error):
                switch error {
                case let error as NSError:
                    switch error.code {
                    case 3840:
                        self = .noResponse
                        
                    default:
                        self = .unknown
                    }
                    
                default:
                    self = .unknown
                }
                
            default:
                self = .unknown
            }
            
        case let error as NSError:
            switch error.domain {
            case NSURLErrorDomain:
                switch error.code {
                case NSURLErrorTimedOut:
                    self = .timeOut
                    
                case NSURLErrorNotConnectedToInternet:
                    self = .noConnection
                 
                case -1020:
                    self = .noConnection
                default:
                    self = .unknown
                }
                
            default:
                self = .unknown
            }
            
        default:
            self = .unknown
        }
        
        self.printError(error: error)
    }
    
    private static func parseGenericError(statusCode: Int,
                                          urlString: String,
                                          message: String?,
                                          subCode: Int?) -> NetworkError {
        switch statusCode {

        case 404: return .notFound
        case 101: return .invalidAccessKey
        case 102: return .inactive_user
        case 103: return .invalid_api_function
        case 104: return .usage_limit_reached
        case 204:
            return .emptyContant
            

        default:
            if let message = message {
                return .other(message: message)
            } else {
                return .unknown
            }
        }
    }
    
    private func printError(error: Error) {
        let code = (error as? RxCocoaURLError)?.getHttpRequestFailed()?.statusCode ?? 0
        let description = (error as? RxCocoaURLError)?.getHttpRequestFailed()?.message ?? ""
        
        print("Error code - \(code)")
        print("---")
        print("Error description - \(description)")
    }
}

extension NetworkError: CustomNSError {
    
    var errorUserInfo: [String : Any] {
        switch self {
            
        case .notFound:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.notFound")]
        case .invalidAccessKey:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.invalidAccessKey")]
        case .inactive_user:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.inactive_user")]
        case .invalid_api_function:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.invalid_api_function")]
        case .usage_limit_reached:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.usage_limit_reached")]
        case .unknown:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.unknown")]
            
        case .timeOut:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.timeOut")]
            
        case .noConnection:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.noConnection")]
            
        case .noResponse:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.noResponse")]
            
        case .badRequest:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.badRequest")]
            
        case .internalServerError:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.internalServerError")]
            
        case .other(let message):
            return [NSLocalizedDescriptionKey: message]
        case .invalidUrl:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.invalidUrl")]
            
        case .cantParseModel:
            return [NSLocalizedDescriptionKey: NSLocalizedString("NetworkError.cantParseModel")]
            
        case .emptyContant:
            return [NSLocalizedDescriptionKey: "Done"]
        case .serverCantParseData:
            return [NSLocalizedDescriptionKey: ""]
        }
    }
}

extension RxCocoaURLError {
    
    func getHttpRequestFailed() -> (statusCode: Int, message: String)? {
        switch self {
        case let .httpRequestFailed(response, data):
            if let data = data,
               let prettyPrintedString = String(data: data, encoding: String.Encoding.utf8) {
                return (statusCode: response.statusCode, message: prettyPrintedString)
            }
            return (statusCode: response.statusCode, message: "")
        default:
            return nil
        }
    }
}
