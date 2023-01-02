//
//  Webservice+EndPoints.swift
//  vGuard
//
//  Created by Admin on 08/12/21.
//

import Foundation


var baseUrl: String {
    switch environment {
    case .qa:
        return "https://vguardqaapi.appskeeper.in/api"
    case .dev:
        return "https://vguarddevapi.appskeeper.in/api"
    case .staging:
        return "https://vguardstgapi.appskeeper.in/api"
    case .production:
        return ""
    }
}

enum Environment {
    case qa
    case dev
    case staging
    case production
}
var appStoreURL = "https://apps.apple.com/app/id"
var environment: Environment = .dev


extension WebServices {
    
    enum EndPoint : String {
        //      MARK: - Weather
        case weahterForecast = "http://api.openweathermap.org/data/2.5/forecast"
        case solarRadiation = "http://api.openweathermap.org/data/2.5/solar_radiation"
        case airQuality = "http://api.openweathermap.org/data/2.5/air_pollution"
        //        ?lat={lat}&lon={lon}&appid={API key}
        //      MARK: - Onboarding
        case socialSignIn = "/v1/user/social-signin"
        case signup  = "/v1/user/signup"
        case login      = "/v1/user/login"
        case sendOTP = "/v1/user/send-otp"
        
        case userDetails = "Users/me"
        case changepassword = "change-password"
        case forgotpassword = "/v1/user/forgot-password"
        case resetPassword = "/v1/user/reset-password"
        case setPassword = "/v1/user/set-password"
        case verifyOTP = "/v1/user/verify-otp"
        case getLocation = "/v1/user/get-location"
        case getUserProfile = "/v1/user/profile"            //GET
        case getNotifications = "/v1/admin/notification"    //GET
        case getProducts = "Products/getMyProducts"
        case addProduct = "Products/submitProductProfile"
        case deleteProductt = "Products/deleteProduct"
        case addFan = "smartFan/submitProductProfileTest"
        case refresh
        
//      MARK: - Home
        case frequentlyUsedDevice = "/v1/product/frequent-used" //PUT
        case frequentlyUsedDevicesList = "/v1/product/frequent-used-list" //GET
        
//      MARK: - MyDevices
        
        
//      MARK: - Complaint/Support
        case getAllComplaintAndRaiseAComplaint = "/v1/request-complaint"  //GET and POST
        case getComplaintDetail = "/v1/request-complaint/{reqId}"  //GET
        case editComplaintAddress = "/v1/request-complaint/address-update"  //PUT
        case complaintRating = "/v1/request-complaint/ratings"  //POST
        
        //      MARK: - Settings
        case updatePhoneNumber = "/v1/user/update-phoneNumber" //PUT
        case submitProfile = "/v1/user/submit-profile"      //PUT
        case logout = "/v1/user/logout"
        case deactivateAccount = "/v1/user/deactivate-aaccount" //PUT
        
//      MARK: - Share Device
        case shareDevice = "/v1/share-device/raise-request"
        case shareDevicesRequestList = "/v1/share-device/request-list"
        case shareDevicesList = "/v1/share-device/sharedDevice-list"
        
//      MARK: - Add Products
        case verifyQr         =   "/v1/product/verify-serialNum"
        case productDeatils   =   "/v1/Retrive-Customer-Asset-Details"
        case ProductAdd       =   "/v1/product" //POST
        case addProductInCRM  =   "/v1/crm-product-resgistration"
        case getProduct       =   "/v1/product/product-list"
        case updateMacID      =   "/v1/product/update-macid"
        
        case editProduct      =   "/v1/product/edit-product" //PUT
        case deleteProduct    =   "/v1/product/delete-product"
        case addunitData      =   "/v1/add-unit-data"
        
        //MARK: - MyDevices
        
        //MARK:- GET solar and BatteryBrand
        case batteryBrandsList = "/v1/product/battery-brand" //GET
        
        var path : String {
            switch self {
            case .weahterForecast, .solarRadiation, .airQuality:
                return self.rawValue
            default:
                let url = baseUrl
                return url + self.rawValue
            }
        }
    }
}
