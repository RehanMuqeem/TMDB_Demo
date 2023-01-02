//
//  AppNetworking.swift
//  vGuard
//
//  Created by Admin on 08/12/21.
//

import Foundation
import Alamofire
import Photos

typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]
typealias SuccessResponse = (_ json : JSON) -> ()
typealias FailureResponse = (NSError) -> (Void)
typealias ResponseMessage = (_ message : String) -> ()
typealias DownloadData = (_ data : Data) -> ()
typealias UploadFileParameter = (fileName: String, key: String, data: Data, mimeType: String)

extension Notification.Name {
    static let NotConnectedToInternet = Notification.Name("Please check your Internet or Wi-Fi connection")
}

enum AppNetworking {
    
    static var timeOutInterval = TimeInterval(30)
    static let username = "vguard"
    static let password = "vguard@123"
    static let Api_Key = "0cf9517e74d671be39d40b6222e87b02"
    
    static func isConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    //Set Header
    static func getHeaders() -> HTTPHeaders {
        let header: HTTPHeaders = ["Authorization": "Bearer \(AppConstants.apiAccessToken.rawValue)",
                                    ]
        return header
    }
    
    static func POST(endPoint : String,
                     parameters : JSONDictionary = [:],
                     headers : HTTPHeaders = [:],
                     loader : Bool = true,
                     success : @escaping (JSON) -> Void,
                     failure : @escaping (NSError) -> Void) {
        self.request(URLString: endPoint, httpMethod: .post, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func POSTWithFiles(endPoint : String,
                              parameters : [String : Any] = [:],
                              files : [UploadFileParameter] = [],
                              headers : HTTPHeaders = [:],
                              loader : Bool = true,
                              success : @escaping (JSON) -> Void,
                              failure : @escaping (NSError) -> Void) {
        
        self.upload(URLString: endPoint, httpMethod: .post, parameters: parameters, files: files, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func POSTWithRawJSON(endPoint : String,
                                parameters : JSONDictionary = [:],
                                headers : HTTPHeaders = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (NSError) -> Void) {
        
        
        self.request(URLString: endPoint, httpMethod: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    
    static func GET(endPoint : String,
                    parameters : [String : Any] = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (NSError) -> Void) {
        
        self.request(URLString: endPoint, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PUT(endPoint : String,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (NSError) -> Void) {
        
        self.request(URLString: endPoint, httpMethod: .put, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    
    static func PUTWithRawJSON(endPoint : String,
                               parameters : JSONDictionary = [:],
                               headers : HTTPHeaders = [:],
                               loader : Bool = true,
                               success : @escaping (JSON) -> Void,
                               failure : @escaping (NSError) -> Void) {
        
        
        self.request(URLString: endPoint, httpMethod: .put, parameters: parameters,encoding: JSONEncoding.default, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PATCH(endPoint : String,
                      parameters : JSONDictionary = [:],
                      encoding: URLEncoding = URLEncoding.httpBody,
                      headers : HTTPHeaders = [:],
                      loader : Bool = true,
                      success : @escaping SuccessResponse,
                      failure : @escaping FailureResponse) {
        
        self.request(URLString: endPoint, httpMethod: .patch, parameters: parameters, encoding: encoding, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func DELETE(endPoint : String,
                       parameters : JSONDictionary = [:],
                       headers : HTTPHeaders = [:],
                       loader : Bool = true,
                       success : @escaping (JSON) -> Void,
                       failure : @escaping (NSError) -> Void) {
        
        self.request(URLString: endPoint, httpMethod: .delete, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    

    private static func request(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                encoding: ParameterEncoding = URLEncoding.httpBody,
                                headers : HTTPHeaders = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (NSError) -> Void) {
                
        var header_auth = self.getHeaders()
        if httpMethod == .put {
            header_auth["content-type"] = "application/json"
            //"application/x-www-form-urlencoded"
        }
        self.makeRequest(URLString: URLString, httpMethod: httpMethod, parameters: parameters, encoding: encoding, headers: header_auth, loader: loader, success: { (json) in
            // print(json)
            let isFailure = json[ApiKey.apiSuccess.rawValue].boolValue
//            let message = json[ApiKey.messagex.rawValue].stringValue
            if isFailure {
//                CommonFunctions.shared.showToastWithMessage(message)
                //"Your session is expired. Please login again.")
            } else {
//                if loader { CommonFunctions.shared.hideActivityLoader() }
                success(json)
            }
        }, failure: failure)
    }
    
    private static func makeRequest(URLString : String,
                                    httpMethod : HTTPMethod,
                                    parameters : JSONDictionary = [:],
                                    encoding: ParameterEncoding = URLEncoding.queryString,
                                    headers : HTTPHeaders = [:],
                                    loader : Bool = true,
                                    success : @escaping (JSON) -> Void,
                                    failure : @escaping (NSError) -> Void) {
        
        Alamofire.request(URLString, method: httpMethod, parameters: parameters, encoding: encoding, headers: self.getHeaders()).responseJSON { (response: DataResponse<Any>) in
            
//            if loader { CommonFunctions.shared.hideActivityLoader() }
            
            printDebug("===================== METHOD =========================")
            printDebug(httpMethod)
            printDebug("===================== ENCODING =======================")
            printDebug(encoding)
            printDebug("===================== URL STRING =====================")
            printDebug(URLString)
            printDebug("===================== HEADERS ========================")
            printDebug(headers)
            printDebug("===================== PARAMETERS =====================")
            printDebug(parameters.description)
            
            switch(response.result) {
            case .success(let value):
                printDebug("===================== RESPONSE =======================")
                printDebug(JSON(value))
                
                let json = JSON(value)
                success(json)
                
            case .failure(let e):
                printDebug("===================== FAILURE =======================")
//                if loader { CommonFunctions.shared.hideActivityLoader() }
                let error = NSError(localizedDescription: e.localizedDescription)
                printDebug(error)
                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                    
                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                    
//                    CommonFunctions.shared.showToastWithMessage(LocalizedString.pleaseCheckInternetConnection.localized)
                    failure(error)
                } else {
                    failure(error)
                }
            }
        }
    }
    
    
    private static func upload(URLString : String,
                               httpMethod : HTTPMethod,
                               parameters : JSONDictionary = [:],
                               files : [UploadFileParameter] = [],
                               headers : HTTPHeaders = [:],
                               loader : Bool = true,
                               success : @escaping (JSON) -> Void,
                               failure : @escaping (NSError) -> Void) {
        
        guard let url = try? URLRequest(url: URLString, method: httpMethod, headers: headers) else { return }
        
//        if loader { CommonFunctions.shared.showActivityLoader() }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            files.forEach({ (fileParamObject) in
                
                multipartFormData.append(fileParamObject.data, withName: fileParamObject.key, fileName: fileParamObject.fileName, mimeType: fileParamObject.mimeType)
            })
            
            parameters.forEach({ (paramObject) in
                
                if let data = (paramObject.value as AnyObject).data(using : String.Encoding.utf8.rawValue) {
                    multipartFormData.append(data, withName: paramObject.key)
                }
            })
            
        }, with: url, encodingCompletion: { encodingResult in
            
            switch encodingResult{
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON(completionHandler: { (response:DataResponse<Any>) in
                    
//                    if loader { CommonFunctions.shared.hideActivityLoader() }
                    
                    printDebug("===================== METHOD =========================")
                    printDebug(httpMethod)
                    printDebug("===================== URL STRING =====================")
                    printDebug(URLString)
                    printDebug("===================== HEADERS ========================")
                    printDebug(headers)
                    printDebug("===================== PARAMETERS =====================")
                    printDebug(parameters)
                    
                    switch response.result{
                    case .success(let value):
                        printDebug("===================== RESPONSE =======================")
                        printDebug(JSON(value))
                        
                        success(JSON(value))
                    case .failure(let e):
                        printDebug("===================== FAILURE =======================")
                        printDebug(e.localizedDescription)
                        
                        if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                            NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                        }
                        failure(e as NSError)
                    }
                })
                
            case .failure(let e):
                
//                if loader { CommonFunctions.shared.hideActivityLoader() }
                
                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                }
                failure(e as NSError)
            }
        })
    }
}
