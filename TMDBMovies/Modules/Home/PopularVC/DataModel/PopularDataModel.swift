//
//  PopularDataModel.swift
//  TMDBMovies
//
//  Created by appinventiv on 27/12/22.
//

import Foundation

// MARK: - PopularDataModel
struct PopularDataModel: Codable {
    var page: Int?
    var results: [CommonMoviesResult]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    init(_ json: JSON = JSON()) {
        self.page = json[ApiKey.page.rawValue].intValue
        self.results = json[ApiKey.results.rawValue].arrayValue.map{CommonMoviesResult($0)}
        self.totalPages = json[ApiKey.totalPages.rawValue].intValue
        self.totalResults = json[ApiKey.totalResults.rawValue].intValue
    }
}

// MARK: - Result
//struct PopularMoviesResult: Codable {
//    var adult: Bool?
//    var backdropPath: String?
//    var genreIDS: [Int]?
//    var id: Int?
//    var originalLanguage, originalTitle, overview: String?
//    var popularity: Double?
//    var posterPath, releaseDate, title: String?
//    var video: Bool?
//    var voteAverage: Double?
//    var voteCount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case genreIDS = "genre_ids"
//        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview, popularity
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case title, video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
//
//    init(_ json: JSON = JSON()) {
//        self.adult = json["adult"].boolValue
//        self.backdropPath = json["backdrop_path"].stringValue
////        self.genreIDS = json["genre_ids"].arrayValue.map{Int($0)}
//        self.id = json["id"].intValue
//        self.originalLanguage = json["original_language"].stringValue
//        self.originalTitle = json["original_title"].stringValue
//        self.overview = json["overview"].stringValue
//        self.popularity = json["popularity"].doubleValue
//        self.posterPath = json["poster_path"].stringValue
//        self.releaseDate = json["release_date"].stringValue
//        self.title = json["title"].stringValue
//        self.video = json["video"].boolValue
//        self.voteAverage = json["vote_average"].doubleValue
//        self.voteCount = json["vote_count"].intValue
//    }
//}

