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
        return "https://api.themoviedb.org/3"
    case .dev:
        return "https://api.themoviedb.org/3"
    case .staging:
        return "https://api.themoviedb.org/3"
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
    
    enum EndPoint: String {
        
        case nowPlayingList               = "/movie/now_playing"
        case popularMoviesList            = "/movie/popular"
        case movieWithId                  = "/movie/"
        case movieWithName                = "/search/movie"
        
        var path : String {
            let url = baseUrl
            return url + self.rawValue
//            switch self {
//            case .otherThanBaseUrl:
//                return self.rawValue
//            default:
//                let url = baseUrl
//                return url + self.rawValue
//            }
        }
    }
    
    static func getUrl(with endPoint: EndPoint) -> String {
        return endPoint.path
    }
}

enum AppConstants: String {
    
    case imageBaseUrl       = "https://image.tmdb.org/t/p/w500/"
    case apiKey             = "0cf9517e74d671be39d40b6222e87b02"
    case apiAccessToken     = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwY2Y5NTE3ZTc0ZDY3MWJlMzlkNDBiNjIyMmU4N2IwMiIsInN1YiI6IjYzYTk3MzcxZWRhNGI3MDA4OWIzZmVjOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._h197J0I2SqdtqBWbGpV-TphJzWHt5i7AJ_7iuQrRCY"
    
}
