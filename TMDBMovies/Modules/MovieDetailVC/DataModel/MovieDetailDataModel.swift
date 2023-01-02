//
//  MovieDetailDataModel.swift
//  TMDBMovies
//
//  Created by appinventiv on 28/12/22.
//

import Foundation

// MARK: - MovieDetailDataModel
struct MovieDetailDataModel: Codable, Equatable {
    static func == (lhs: MovieDetailDataModel, rhs: MovieDetailDataModel) -> Bool {
        return (lhs.originalTitle == rhs.originalTitle) && (lhs.id == rhs.id) && (lhs.budget == rhs.budget)
    }
    
    var adult: Bool?
    var backdropPath: String?
    var belongsToCollection: BelongsToCollection?
    var budget: Int?
    var genres: [Genre]?
    var homepage: String?
    var id: Int?
    var imdbID, originalLanguage, originalTitle, overview: String?
    var popularity: Double?
    var posterPath: String?
    var productionCompanies: [ProductionCompany]?
    var productionCountries: [ProductionCountry]?
    var releaseDate: String?
    var revenue, runtime: Int?
    var spokenLanguages: [SpokenLanguage]?
    var status, tagline, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var credits: Credits?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case credits
    }
    
    init(_ json: JSON = JSON()) {
        self.adult = json["adult"].boolValue
        self.backdropPath = json["backdrop_path"].stringValue
        self.belongsToCollection = BelongsToCollection(json["belongs_to_collection"])
        self.budget = json["budget"].intValue
        self.genres = json["genres"].arrayValue.map{ Genre($0) }
        self.homepage = json["homepage"].stringValue
        self.id = json["id"].intValue
        self.imdbID = json["imdb_id"].stringValue
        self.originalLanguage = json["original_language"].stringValue
        self.originalTitle = json["original_title"].stringValue
        self.overview = json["overview"].stringValue
        if self.overview == "" { self.overview = "NA" }
        self.popularity = json["popularity"].doubleValue
        self.posterPath = json["poster_path"].stringValue
        self.productionCompanies = json["production_companies"].arrayValue.map{ ProductionCompany($0) }
        self.productionCountries = json["production_countries"].arrayValue.map{ ProductionCountry($0) }
        self.releaseDate = json["release_date"].stringValue
        self.revenue = json["revenue"].intValue
        self.runtime = json["runtime"].intValue
        if self.runtime == 0 { self.runtime = 0 }
        self.spokenLanguages = json["spoken_languages"].arrayValue.map{ SpokenLanguage($0) }
        self.status = json["status"].stringValue
        self.tagline = json["tagline"].stringValue
        self.title = json["title"].stringValue
        self.video = json["video"].boolValue
        self.voteAverage = json["vote_average"].doubleValue
        self.voteCount = json["vote_count"].intValue
        self.credits = Credits(json["credits"])
    }
    
}

// MARK: - Credits
struct Credits: Codable {
    var cast: [Cast]?
    var crew: [Cast]?
    
    init(_ json: JSON = JSON()) {
        self.cast = json["cast"].arrayValue.map{ Cast($0) }
        self.crew = json["crew"].arrayValue.map{ Cast($0) }
    }
}

// MARK: - Cast
struct Cast: Codable {
    var adult: Bool?
    var gender, id: Int?
    var knownForDepartment: Department?
    var name, originalName: String?
    var popularity: Double?
    var profilePath: String?
    var castID: Int?
    var character, creditID: String?
    var order: Int?
    var department: Department?
    var job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    init(_ json: JSON = JSON()) {
        self.adult = json["adult"].boolValue
        self.gender = json["gender"].intValue
        self.id = json["id"].intValue
        self.knownForDepartment = Department(rawValue: json["known_for_department"].stringValue)
        self.name = json["name"].stringValue
        self.originalName = json["original_name"].stringValue
        self.popularity = json["popularity"].doubleValue
        self.profilePath = json["profile_path"].stringValue
        self.castID = json["cast_id"].intValue
        self.character = json["character"].stringValue
        if self.character == "Self" { self.character = "NA" }
        self.creditID = json["credit_id"].stringValue
        self.order = json["order"].intValue
        self.department = Department(rawValue: json["department"].stringValue)
        self.job = json["job"].stringValue
    }
    
}

enum Department: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case lighting = "Lighting"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
}


// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    var id: Int?
    var name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
    init(_ json: JSON = JSON()) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.posterPath = json["poster_path"].stringValue
        self.backdropPath = json["backdrop_path"].stringValue
    }
}

// MARK: - Genre
struct Genre: Codable {
    
    var id: Int?
    var name: String?
    
    init(_ json: JSON = JSON()) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
    
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    
    var id: Int?
    var logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    init(_ json: JSON = JSON()) {
        self.id = json["id"].intValue
        self.logoPath = json["logo_path"].stringValue
        self.name = json["name"].stringValue
        self.originCountry = json["origin_country"].stringValue
    }
    
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    
    var iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
    
    init(_ json: JSON = JSON()) {
        self.iso3166_1 = json["iso_3166_1"].stringValue
        self.name = json["name"].stringValue
    }
    
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    var englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
    
    init(_ json: JSON = JSON()) {
        self.englishName = json["english_name"].stringValue
        self.iso639_1 = json["iso_3166_1"].stringValue
        self.name = json["name"].stringValue
    }
    
}
