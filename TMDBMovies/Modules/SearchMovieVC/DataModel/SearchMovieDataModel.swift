//
//  SearchMovieDataModel.swift
//  TMDBMovies
//
//  Created by appinventiv on 29/12/22.
//

import Foundation

//MARK: - SearchMovieDataModel
struct SearchMovieDataModel: Codable {
    var page: Int?
    var results: [CommonMoviesResult]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    init(_ json: JSON = JSON())  {
        self.page = json[ApiKey.page.rawValue].intValue
        self.results = json[ApiKey.results.rawValue].arrayValue.map{ CommonMoviesResult($0) }
        self.totalPages = json[ApiKey.totalPages.rawValue].intValue
        self.totalResults = json[ApiKey.totalResults.rawValue].intValue
    }
    
}
