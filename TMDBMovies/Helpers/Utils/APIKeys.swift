//
//  APIKeys.swift
//  Pave
//
//  Created by Rishabh on 13/08/21.
//

import UIKit

enum ApiKey: String {
    
    case code = "code"
    case apiSuccess = "success"
    case message = "message"
    case data = "data"
    case items = "items"
    case page = "page"
    case results = "results"
    case limit = "limit"
    case totalPages = "total_pages"
    case totalResults = "total_results"
    
}

//MARK:- App Keys
//=======================
enum AppKeys {
    static var platform: String { return "2" }
    static var VGuardApikeyAccess: String { return "1234" }
    static var deviceID: String { return UIDevice.current.identifierForVendor?.uuidString ?? "" }
    static var deviceToken: String { return UIDevice.current.identifierForVendor?.uuidString ?? "" }// here we need APNs token
    static var timeZone: String { TimeZone.current.description.components(separatedBy: " ").first ?? "" }

}

enum ApiCode {
    
    static var success                  : Int { return 200 } // Success
    static var unauthorizedRequest      : Int { return 206 } // Unauthorized request
    static var headerMissing            : Int { return 207 } // Header is missing
    static var phoneNumberAlreadyExist  : Int { return 208 } // Phone number alredy exists
    static var socialIDNotAvaliable     : Int { return 410 } // SocialID Not Avaliable
    static var requiredParametersMissing: Int { return 418 } // Required Parameter Missing or Invalid
    static var fileUploadFailed         : Int { return 421 } // File Upload Failed
    static var pleaseTryAgain           : Int { return 500 } // Please try again
    static var tokenExpired             : Int { return 501 } // Token expired refresh token needed to be generated
}
