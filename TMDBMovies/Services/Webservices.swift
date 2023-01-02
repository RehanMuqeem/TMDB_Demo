//
//  Webservices.swift
//  vGuard
//
//  Created by Admin on 08/12/21.
//

import Foundation
import Alamofire
//import Mixpanel
enum WebServices { }

extension NSError {
    
    convenience init(localizedDescription : String) {
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}

extension WebServices {
    
    // MARK:- Common POST API
    //=======================
    static func commonPostAPI(parameters: JSONDictionary,
                              endPoint: EndPoint,
                              loader: Bool = true,
                              success : @escaping SuccessResponse,
                              failure : @escaping FailureResponse) {
        
        AppNetworking.POST(endPoint: endPoint.path, parameters: parameters, loader: loader) { (json) in
            let code = json[ApiKey.code.rawValue].intValue
            let msg = json[ApiKey.message.rawValue].stringValue
            switch code {
            case ApiCode.success: success(json)
            case ApiCode.socialIDNotAvaliable : failure(NSError(code: code, localizedDescription: msg))
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        } failure: { (error) in
            failure(error as NSError)
        }
    }
    
    static func commonPostRawJSONAPI(parameters: JSONDictionary,
                                     endPoint: EndPoint,
                                     loader: Bool = true,
                                     success : @escaping SuccessResponse,
                                     failure : @escaping FailureResponse) {
        
        AppNetworking.POSTWithRawJSON(endPoint: endPoint.path, parameters: parameters, loader: loader, success: { (json) in
            let code = json[ApiKey.code.rawValue].intValue
            let msg = json[ApiKey.message.rawValue].stringValue
            switch code {
            case ApiCode.success: success(json)
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        }) { (error) in
            failure(error)
        }
    }
    
    //MARK:- COMMON GET API
    //=====================
    static func commonGetAPI(parameters: JSONDictionary,
                             endPoint: EndPoint,
                             loader: Bool = true,
                             success : @escaping SuccessResponse,
                             failure : @escaping FailureResponse) {
        
        AppNetworking.GET(endPoint: endPoint.path, parameters: parameters, loader: loader) { (json) in
            let code = json[ApiKey.code.rawValue].intValue
            let msg = json[ApiKey.message.rawValue].stringValue
            switch code {
            case ApiCode.success: success(json)
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        } failure: { (error) in
            failure(error as NSError)
        }
    }
    
    //MARK:- COMMON PUT API
    //=====================
    static func commonPutAPI(parameters: JSONDictionary,
                             endPoint: EndPoint,
                             loader: Bool = true,
                             success : @escaping SuccessResponse,
                             failure : @escaping FailureResponse) {
        
        AppNetworking.PUT(endPoint: endPoint.path, parameters: parameters, loader: loader) { (json) in
            let code = json[ApiKey.code.rawValue].intValue
            let msg = json[ApiKey.message.rawValue].stringValue
            switch code {
            case ApiCode.success: success(json)
            case ApiCode.socialIDNotAvaliable : failure(NSError(code: code, localizedDescription: msg))
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        } failure: { (error) in
            failure(error as NSError)
        }
    }
    
    static func hitPutAPI(parameters: JSONDictionary, endPoint: EndPoint, loader: Bool = true, success: @escaping SuccessResponse, failure: @escaping FailureResponse) {
        
        AppNetworking.PUT(endPoint: endPoint.path, parameters: parameters, loader: loader) { (json) in
            let code = json[ApiKey.code.rawValue].intValue
            let msg = json[ApiKey.message.rawValue].stringValue
            switch code {
            case ApiCode.success: success(json)
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        } failure: { error in
            failure(error as NSError)
        }
    }
    
    static func hitGetAPI(parameters: JSONDictionary, endPointStr: String, loader: Bool = true, success: @escaping SuccessResponse, failure: @escaping FailureResponse) {
        AppNetworking.GET(endPoint: endPointStr, parameters: parameters, loader: loader) { (json) in
            success(json)
        } failure: { error in
            failure(error as NSError)
        }
    }
    
    static func hitGetAPI(parameters: JSONDictionary, endPoint: EndPoint, loader: Bool = true, success: @escaping SuccessResponse, failure: @escaping FailureResponse) {
        AppNetworking.GET(endPoint: endPoint.path, parameters: parameters, loader: loader) { (json) in
            success(json)
        } failure: { error in
            failure(error as NSError)
        }
    }
    
}
