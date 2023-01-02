//
//  NowPlayingVM.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import Foundation

class NowPlayingVM {
    
//  MARK: - Properties
    weak var delegate: CommonApiCallDelegate?
    private var nowPlayingData: [CommonMoviesResult] = []
    private var nowPlayingCellData: [CommonMovieCellVM] = []
    private var isNextPageAvailable: Bool = true
    private var isAPIInProgress: Bool = false
    private var pageNo: Int = 1
    private var limit: Int = 10
    
//  MARK: - Getter Functions
    func getRowCount() -> Int { nowPlayingData.count }
    
    func getCellVM(at index: Int) -> CommonMovieCellVM { self.nowPlayingCellData[index] }
    
    func getAllMoviesToPushOnsearchVC() -> [CommonMovieCellVM] { self.nowPlayingCellData }
    
    func getMovieId(at index: Int) -> Int { self.nowPlayingData[index].id ?? 0 }
    
    func checkAndCallApiForNowPlaying() {
        guard self.isNextPageAvailable && !self.isAPIInProgress else { return }
        self.callApi()
    }
    
//  MARK: - Private Functions (update remote data)
    private func updateNowPlayingData(with list: [CommonMoviesResult]) {
        self.nowPlayingData.append(contentsOf: list)
        self.nowPlayingCellData.append(contentsOf: list.map{ CommonMovieCellVM($0) })
    }
    
}

//MARK: - Extension Api calls
extension NowPlayingVM {
    
    private func callApi() {
        self.isAPIInProgress = true
        let param: JSONDictionary = [
            "api_key": AppConstants.apiKey.rawValue,
            ApiKey.page.rawValue: self.pageNo,
//            ApiKey.limit.rawValue: 20
        ]
        WebServices.hitGetAPI(parameters: param, endPoint: .nowPlayingList) { [weak self] json in
            guard let self = self else { return }
            printDebug(json)
//            DispatchQueue.main.async {///the api call back comes over the background thread now update UI over the main thread.
            self.isNextPageAvailable = json[ApiKey.totalPages.rawValue].intValue > self.pageNo
            self.pageNo += 1
            self.updateNowPlayingData(with: json[ApiKey.results.rawValue].arrayValue.map{CommonMoviesResult($0)})
            self.delegate?.didFetchAPIResult(with: true, msg: "success")
            self.isAPIInProgress = false
//            }
        } failure: { [weak self] error in
            self?.delegate?.didFetchAPIResult(with: false, msg: error.localizedDescription)
            self?.isNextPageAvailable  = false
            self?.isAPIInProgress = false
        }
    }
    
}
