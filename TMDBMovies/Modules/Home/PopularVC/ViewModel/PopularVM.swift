//
//  PopularVM.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import Foundation

protocol CommonApiCallDelegate: NSObjectProtocol {
    func didFetchAPIResult(with success: Bool, msg: String)
}

class PopularVM {
    
//  MARK: - Properties
    weak var delegate: CommonApiCallDelegate?
    private var popularMoviesData: [CommonMoviesResult] = []
    private var popularMoviesCellData: [CommonMovieCellVM] = []
    private var isNextPageAvailable: Bool = true
    private var isApiInProgress: Bool = false
    private var pageNo: Int = 1
    private var limit: Int = 10
    
//  MARK: - Getter Functions
    func getRowCount() -> Int { return popularMoviesData.count }
    
    func getCellVM(at index: Int) -> CommonMovieCellVM { self.popularMoviesCellData[index] }
    
    func getAllMoviesData() -> [CommonMovieCellVM] { self.popularMoviesCellData }
    
    func getMovieId(at index: Int) -> Int { self.popularMoviesData[index].id ?? 0}
    
    func checkAndCallApiForPopular() {
        guard self.isNextPageAvailable && !self.isApiInProgress else{ return }
        self.callApi()
    }
    
//  MARK: - Private Functions (Update Data)
    private func updatePopularMoviesData(with list: [CommonMoviesResult]) {
        self.popularMoviesData.append(contentsOf: list)
        self.popularMoviesCellData.append(contentsOf: list.map{ CommonMovieCellVM($0) })
    }
    
//  MARK: - Api call
    private func callApi() {
        self.isApiInProgress = true
        let param: JSONDictionary = [
            "api_key": AppConstants.apiKey.rawValue,
            ApiKey.page.rawValue: self.pageNo
        ]
        WebServices.hitGetAPI(parameters: param, endPoint: .popularMoviesList) { [weak self] json in
            guard let self = self else { return }
            printDebug(json)
            self.isNextPageAvailable = json[ApiKey.totalPages.rawValue].intValue > self.pageNo
            self.pageNo += 1
            self.updatePopularMoviesData(with: json[ApiKey.results.rawValue].arrayValue.map{CommonMoviesResult($0)})
            self.delegate?.didFetchAPIResult(with: true, msg: "success")
            self.isApiInProgress = false
        } failure: { [weak self] error in
            self?.delegate?.didFetchAPIResult(with: false, msg: error.localizedDescription)
            self?.isNextPageAvailable  = false
            self?.isApiInProgress = false
        }
    }
    
}
