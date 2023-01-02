//
//  MovieDetailVM.swift
//  TMDBMovies
//
//  Created by appinventiv on 27/12/22.
//

import Foundation

protocol MovieDetailVMDelegate: NSObjectProtocol {
    func didFetchMovieDetail(isSuccess: Bool, movieName: String)
}

class MovieDetailVM {
    
    enum DetailSections {
        case posterSection, detailSection, castingActors, genreSection
    }
    
    enum DetailsCellTypes {
        case posterCell, detailCell, castCell
    }
    
//  MARK: - Properties
    weak var delegate: MovieDetailVMDelegate?
    private var sections: [DetailSections] = []
    private var cellsArray: [[DetailsCellTypes]] = []
    private var cellValuesArray: [[(String, String)]] = []
    private var movieCastPoster: [String] = []
    private var movieData: MovieDetailDataModel = MovieDetailDataModel()

//  MARK: - Initializer/Constructor
    init(movieId: Int) {
        self.hitGetMovieDataApi(with: movieId)
    }
    
//  MARK: - Private Functions (UI setup)
    private func createData(with data: MovieDetailDataModel) {
        self.sections.removeAll()
        self.cellsArray.removeAll()
        self.createPosterSection(desc: data.overview ?? "", posterPath: data.posterPath ?? "")
        self.createMovieDetailsSection(data: data)
        self.createCastingMembersSection(cast: data.credits?.cast ?? [])
        self.createGenreSection(genres: data.genres ?? [])
    }
    
    private func createPosterSection(desc: String, posterPath: String) {
        self.sections.append(.posterSection)
        let description = "Description and Overview: " + desc
        self.cellValuesArray.append([(description, posterPath)])
        self.cellsArray.append([.posterCell])
    }
    
    private func createMovieDetailsSection(data: MovieDetailDataModel) {
        self.sections.append(.detailSection)
        var cells = [DetailsCellTypes]()
        var cellsValues = [(String, String)]()
        if let runTime = data.runtime?.minutesToHoursAndMinutes, runTime != "" {
            cellsValues.append(("Running time (minutes):", runTime))
            cells.append(.detailCell)
        }
        cellsValues.append(("Release Date:", data.releaseDate?.toDateText() ?? ""))
        cells.append(.detailCell)
        cellsValues.append(("Total budget:", "$ \((data.budget ?? 0)/1000000) Million(s)"))
        cells.append(.detailCell)
        cellsValues.append(("Average votes:", "\(data.voteAverage?.round(toPlaces: 1) ?? 0.0)/10"))
        cells.append(.detailCell)
        cellsValues.append(("Total votes:", "\(data.voteCount ?? 0)"))
        cells.append(.detailCell)
        cellsValues.append(("Popularity:", "\(data.popularity?.round(toPlaces: 2) ?? 0.0)"))
        cells.append(.detailCell)
        if let language = data.originalLanguage {
            if language == "en" {
                cellsValues.append(("Original Language:", "English"))
            } else if language == "id" {
                cellsValues.append(("Original Language:", "Other language"))
            } else {
                cellsValues.append(("Original Language:", "Others"))
            }
        }
        cells.append(.detailCell)
        self.cellsArray.append(cells)
        self.cellValuesArray.append(cellsValues)
    }
    
    private func createCastingMembersSection(cast: [Cast]) {
        self.sections.append(.castingActors)
        var cells = [DetailsCellTypes]()
        var cellsValues = [(String, String)]()
        for i in 0..<5 {
            cellsValues.append((cast[i].originalName ?? "", cast[i].character ?? ""))
            cells.append(.castCell)
            self.movieCastPoster.append(cast[i].profilePath ?? "")
        }
        self.cellsArray.append(cells)
        self.cellValuesArray.append(cellsValues)
    }
    
    private func createGenreSection(genres: [Genre]) {
        self.sections.append(.genreSection)
        var cellsValue: [(String, String)] = []
        var cells: [DetailsCellTypes] = []
        for i in 0..<genres.count {
            cellsValue.append((genres[i].name ?? "", ""))
            cells.append(.detailCell)
        }
        self.cellsArray.append(cells)
        self.cellValuesArray.append(cellsValue)
    }
    
//  MARK: - Getter Functions
    func getSectionsCount() -> Int { self.sections.count }
    func getSections(at index: Int) -> DetailSections { self.sections[index] }
    func getCellsCount(in section: Int) -> Int { self.cellsArray[section].count }
    func getCellType(at indexPath: IndexPath) -> DetailsCellTypes { self.cellsArray[indexPath.section][indexPath.row] }
    func getCellValue(at indexPath: IndexPath) -> (String, String) { self.cellValuesArray[indexPath.section][indexPath.row] }
    func getMovieCrewPoster(at index: Int) -> String { self.movieCastPoster[index] }
    func getMovieData() -> MovieDetailDataModel { self.movieData } //For testing
    func getMovieNameAndId() -> (String, Int) { (self.movieData.originalTitle ?? "", self.movieData.id ?? 0) } //For testing
    
}

//MARK: - Extension Api Calls
extension MovieDetailVM {
    
    private func hitGetMovieDataApi(with movieId: Int) {
        let param: JSONDictionary = [
            "api_key": AppConstants.apiKey.rawValue,
            "append_to_response": "credits"
        ]
        let urlStr = WebServices.getUrl(with: .movieWithId) + "\(movieId)"
        WebServices.hitGetAPI(parameters: param, endPointStr: urlStr) { [weak self] json in
            printDebug(json)
            DispatchQueue.main.async {
                let modelData = MovieDetailDataModel(json)
                self?.movieData = modelData
                self?.createData(with: modelData)
                self?.delegate?.didFetchMovieDetail(isSuccess: true, movieName: modelData.title ?? "")
            }
        } failure: { [weak self] error in
            print(" >>> ", error.localizedDescription)
            self?.delegate?.didFetchMovieDetail(isSuccess: false, movieName: "No movie found")
        }
    }
    
}
