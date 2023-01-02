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
            let code = json[ApiKey.code].intValue
            let msg = json[ApiKey.message].stringValue
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
            let code = json[ApiKey.code].intValue
            let msg = json[ApiKey.message].stringValue
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
            let code = json[ApiKey.code].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json)
            case ApiCode.socialIDNotAvaliable : failure(NSError(code: code, localizedDescription: msg))
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
            let code = json[ApiKey.code].intValue
            let msg = json[ApiKey.message].stringValue
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
            let code = json[ApiKey.code].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json)
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        } failure: { error in
            failure(error as NSError)
        }
    }
    
    static func getWeatherAPI(parameters: JSONDictionary, endPoint: EndPoint, loader: Bool = true, success: @escaping SuccessResponse, failure: @escaping FailureResponse) {
        AppNetworking.GET(endPoint: endPoint.path, parameters: parameters) { (json) in
            let code = json["cod"].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json)
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        } failure: { error in
            failure(error as NSError)
        }
    }
    
    static func getAQIAPI(parameters: JSONDictionary, endPoint: EndPoint = .airQuality, loader: Bool = true, success: @escaping SuccessResponse, failure: @escaping FailureResponse) {
        AppNetworking.GET(endPoint: endPoint.path, parameters: parameters) { (json) in
//            let code = json["list"]["main"]["aqi"].intValue
//            let msg = json[ApiKey.message].stringValue
            success(json)
        } failure: { error in
            failure(error as NSError)
        }
    }
    
    static func hitGetAPI(parameters: JSONDictionary, endPoint: EndPoint, loader: Bool = true, success: @escaping SuccessResponse, failure: @escaping FailureResponse) {
        AppNetworking.GET(endPoint: endPoint.path, parameters: parameters, loader: loader) { (json) in
            let code = json[ApiKey.code].intValue
            let msg = json[ApiKey.message].stringValue
            switch code {
            case ApiCode.success: success(json)
            default: failure(NSError(code: code, localizedDescription: msg))
            }
        } failure: { error in
            failure(error as NSError)
        }
    }
    
    // MARK:- Refresh Token
    //=====================
    static func refreshToken(success: @escaping SuccessResponse,
                             failure: @escaping FailureResponse) {
        
        let params : [String:Any] = [ApiKey.refreshToken:UserModel.main.refreshToken,
                                     ApiKey.name:UserModel.main.name]
        self.commonPostAPI(parameters: params, endPoint: .refresh, success: { (json) in
            let token = json[ApiKey.token].stringValue
            let refreshToken = json["refresh_token"].stringValue
            UserModel.main.token = token
            UserModel.main.refreshToken = refreshToken
            UserModel.main.saveToUserDefaults()
            success(json)
        }, failure: failure)
    }
    
    
    // MARK: - Sign Up
    //===============
    static func signUp(parameters: JSONDictionary,
                       success: @escaping UserControllerSuccess,
                       failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .signup) { json in
            UserModel.main = UserModel(json[ApiKey.data])
//            Mixpanel.mainInstance().identify(distinctId: UserModel.main.userId)
//            Mixpanel.mainInstance().people.set(properties: ["$name":UserModel.main.name,
//                                                            "$phone":UserModel.main.phone,
//                                                            "$city":UserModel.main.city,
//                                                            "$state":UserModel.main.state])
            
//            MixpanelHelper.postEvent(eventType: .SIGN_UP, value: [ApiKey.name:UserModel.main.name ,
//                                                                  ApiKey.phone:UserModel.main.phone,
//                                                                  ApiKey.city:UserModel.main.city,
//                                                                  ApiKey.state:UserModel.main.state,
//                                                                  "Platform":"iOS"])
            success(UserModel.main)
            CommonFunctions.shared.showToastWithMessage(json[ApiKey.message].stringValue)
            printDebug(">>>>> create acc success")
        } failure: { error in
            failure(error)
        }
    }
    
    // MARK: - Social Sign Up
    //===============
    static func socialSignUp(parameters: JSONDictionary,
                             success: @escaping UserControllerSuccess,
                             failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .socialSignIn) { json in
            UserModel.main = UserModel(json[ApiKey.data])
//            Mixpanel.mainInstance().identify(distinctId: UserModel.main.userId)
//            Mixpanel.mainInstance().people.set(properties: ["$name":UserModel.main.name,
//                                                            "$email":UserModel.main.email,
//                                                            "$phone":UserModel.main.phone,
//                                                            "$city":UserModel.main.city,
//                                                            "$state":UserModel.main.state])
//
//            MixpanelHelper.postEvent(eventType: .SIGN_UP, value: [ApiKey.name:UserModel.main.name ,
//                                                                  ApiKey.phone:UserModel.main.phone,
//                                                                  ApiKey.city:UserModel.main.city,
//                                                                  ApiKey.state:UserModel.main.state,
//                                                                  "Platform":"iOS"])
            success(UserModel.main)
            CommonFunctions.shared.showToastWithMessage(json[ApiKey.message].stringValue)
            printDebug(">>>>> create acc success")
        } failure: { error in
            failure(error)
        }
    }
    
    
    // MARK: - Login
    //=============
    static func login(parameters: JSONDictionary,
                      success: @escaping UserControllerSuccess,
                      failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .login) { json in
            UserModel.main = UserModel(json[ApiKey.data])
//            Mixpanel.mainInstance().identify(distinctId: UserModel.main.userId)
//            Mixpanel.mainInstance().people.set(properties: ["$name":UserModel.main.name,
//                                                            "$phone":UserModel.main.phone,
//                                                            "$city":UserModel.main.city,
//                                                            "$state":UserModel.main.state])
//
//            MixpanelHelper.postEvent(eventType: .LogIn, value: [ApiKey.name:UserModel.main.name ,
//                                                                ApiKey.phone:UserModel.main.phone,
//                                                                ApiKey.city:UserModel.main.city,
//                                                                ApiKey.state:UserModel.main.state,
//                                                                "Platform":"iOS"])
            let token = json[ApiKey.data][ApiKey.accessToken].stringValue
            let refreshToken = json[ApiKey.data][ApiKey.accessToken].stringValue
            AppUserDefaults.save(value: token, forKey: .accesstoken)
            AppUserDefaults.save(value: refreshToken, forKey: .refresToken)
            //            UserModel.main.language = "en"
            success(UserModel.main)
            CommonFunctions.shared.showToastWithMessage(json[ApiKey.message].stringValue)
        } failure: { error in
            failure(error)
        }
        
    }
    
    // MARK:- Login
    //=============
    static func userDetails(parameters: JSONDictionary,
                            success: @escaping UserControllerSuccess,
                            failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .userDetails) { (json) in
            UserModel.main = UserModel(json["userDetails"])
            success(UserModel.main)
        } failure: { error in
            failure(error)
        }
    }
    
    // MARK:- Forgot Password
    //=======================
    static func forgotPassword(parameters: JSONDictionary,
                               success: @escaping SuccessResponse,
                               failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .forgotpassword, success: success, failure: failure)
    }
    
    // MARK:- Logout User
    //===================
    static func logoutAPI(parameters: JSONDictionary,
                          success: @escaping SuccessResponse,
                          failure: @escaping FailureResponse) {
        self.commonPostAPI(parameters: parameters, endPoint: .logout, success: success, failure: failure)
    }
    
    // MARK:- GET PRODUCT
    //=======================
    static func getProduct(parameters: JSONDictionary,
                           success: @escaping SuccessResponse,
                           failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .getProducts, success: success, failure: failure)
    }
    
    // MARK:- ADD PRODUCT
    //=======================
    static func addProduct(parameters: JSONDictionary,
                           success: @escaping SuccessResponse,
                           failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .addProduct, success: success, failure: failure)
    }
    
    // MARK:- ADD FAN
    //=======================
    static func addFan(parameters: JSONDictionary,
                       success: @escaping SuccessResponse,
                       failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .addFan, success: success, failure: failure)
    }
    
    // MARK:- DELETE PRODUCT
    //=======================
    static func deleteProduct(parameters: JSONDictionary,
                              success: @escaping SuccessResponse,
                              failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .deleteProduct, success: success, failure: failure)
    }
    
    //MARK:- SHARE REQUEST
    //====================
    static func getShareRequest(parameters: JSONDictionary,
                                success: @escaping SuccessResponse,
                                failure: @escaping FailureResponse) {
        
        self.commonGetAPI(parameters: parameters, endPoint: .shareDevicesRequestList, success: success, failure: failure)
    }
    
    //MARK:- SHARE DEVICE
    //===================
    
    static func getShareDevice(parameters: JSONDictionary,
                               success: @escaping SuccessResponse,
                               failure: @escaping FailureResponse) {
        
        self.commonGetAPI(parameters: parameters, endPoint: .shareDevicesList, success: success, failure: failure)
    }
    
    
    
    //MARK:- GETDEVICES_LIST
    //======================
    static func getDevices(parameters: JSONDictionary,
                           loader:Bool=false,
                           success: @escaping SuccessResponse,
                           failure: @escaping FailureResponse) {
        
        self.commonGetAPI(parameters: parameters, endPoint: .getProduct,loader: loader, success: success, failure: failure)
    }
    
    
    //MARK:- verifyQRCOde
    //======================
    static func getSerialNumber(parameters: JSONDictionary,
                                success: @escaping SuccessResponse,
                                failure: @escaping FailureResponse) {
        
        self.commonGetAPI(parameters: parameters, endPoint: .verifyQr, success: success, failure: failure)
    }
    
    
    
    //MARK:- GETDEVICES_Details
    //======================
    static func getDevicesDetailss(parameters: JSONDictionary,
                                   success: @escaping SuccessResponse,
                                   failure: @escaping FailureResponse) {
        
        self.commonGetAPI(parameters: parameters, endPoint: .productDeatils, success: success, failure: failure)
    }
    
    //MARK:- AddDEvice
    //================
    static func addProductt(parameters: JSONDictionary,
                            success: @escaping SuccessResponse,
                            failure: @escaping FailureResponse) {
        
        self.commonPostRawJSONAPI(parameters: parameters, endPoint: .ProductAdd, success: success, failure: failure)
    }
    
    //MARK:- GET_ADDRESS
    //================
    static func getAddress(parameters: JSONDictionary,
                            success: @escaping SuccessResponse,
                            failure: @escaping FailureResponse) {
        
        self.commonPostAPI(parameters: parameters, endPoint: .getLocation, success: success, failure: failure)
    }
    
  //MARK:- UPDATE MAC ADDRESS
  //=======================
    static func updateMacAddress(parameters: JSONDictionary,
                            success: @escaping SuccessResponse,
                            failure: @escaping FailureResponse) {
        
        self.commonPutAPI(parameters: parameters, endPoint: .updateMacID, success: success, failure: failure)
    }
    
    //MARK:- DELETE PRODUCT
    //=====================
    static func deleteAddedProduct(parameters: JSONDictionary,
                            success: @escaping SuccessResponse,
                            failure: @escaping FailureResponse) {
        
        self.commonPutAPI(parameters: parameters, endPoint: .deleteProduct, success: success, failure: failure)
    }
    
    
    //MARK:- GET_Frequent_DEVICES
    //======================
    static func getFrequentDevicesDetailss(parameters: JSONDictionary,
                                           loader:Bool=false,
                                   success: @escaping SuccessResponse,
                                   failure: @escaping FailureResponse) {
        
        self.commonGetAPI(parameters: parameters, endPoint: .frequentlyUsedDevicesList,loader: loader, success: success, failure: failure)
    }
    
}
