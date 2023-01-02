//
//  SearchMovieVM.swift
//  TMDBMovies
//
//  Created by appinventiv on 29/12/22.
//

import Foundation

protocol SearchMovieVMDelegate: NSObjectProtocol {
    func getRemoteData(isSuccess: Bool, count: Int)
}

class SearchMovieVM {
    
    enum SearchBarAction {
        case didPress, didBegin, didEnd, shouldChangeText, searchPress
    }
    
//  MARK: - Properties
    weak var delegate: SearchMovieVMDelegate?
    var searchBarAction: ((_ actionType: SearchBarAction, _ searchKey: String) -> Void)? = nil
    private var localCollection: [CommonMovieCellVM] = []
    private var localFilteredCollection: [CommonMovieCellVM] = []
    private var remoteSearchedCollection: [CommonMovieCellVM] = []

//  MARK: - Setter Functions
    func setLocalCollection(data: [CommonMovieCellVM]) {
        self.localCollection = data
        self.localFilteredCollection = data
    }
    
//  MARK: - Getter Functions
    func getRowsCount() -> Int {
        if self.localFilteredCollection.count == 0 {
            return self.remoteSearchedCollection.count
        } else {
            return self.localFilteredCollection.count
        }
    }
    
    func getCellVM(at index: Int) -> CommonMovieCellVM {
        if self.localFilteredCollection.count == 0 {
            return self.remoteSearchedCollection[index]
        } else {
            return self.localFilteredCollection[index]
        }
    }
    
    func getMovieId(at index: Int) -> Int {
        if self.localFilteredCollection.count == 0 {
            return self.remoteSearchedCollection[index].getMovieId()
        } else {
            return self.localFilteredCollection[index].getMovieId()
        }
    }
    
//  MARK: - Filter Functions
    func getMovieByName(name: String) {
        self.hitLocalSearch(with: name)
        if self.localFilteredCollection.count == 0 {
            self.getRemoteMovieByName(movieName: name)
            printDebug(" >>> Hit Remote Api")
        } else {
            let valCount = self.localFilteredCollection.count
            self.delegate?.getRemoteData(isSuccess: true, count: valCount)
            printDebug(" >>> Local data present with \(valCount) values")
        }
    }
    
//  MARK: - Private Functions
    private func hitLocalSearch(with name: String) {
        if name.isEmpty {
            self.localFilteredCollection = self.localCollection
        } else {
            self.localFilteredCollection = self.localCollection.filter ({
                $0.getMovieTitle().lowercased().contains(name.lowercased())
            })
        }
    }
    
    private func updateRemoteData(with list: [CommonMoviesResult]) {
        self.remoteSearchedCollection.removeAll()
        self.remoteSearchedCollection.append(contentsOf: list.map { CommonMovieCellVM($0) })
    }
    
}

//MARK: -  Extension Api call Get remote movie search
extension SearchMovieVM {
    
    private func getRemoteMovieByName(movieName: String) {
//    https://api.themoviedb.org/3/search/movie?api_key=0cf9517e74d671be39d40b6222e87b02&query=the+l
        let queryMovieName = movieName.replacingOccurrences(of: " ", with: "+").lowercased()
        let param: JSONDictionary = [
                                    "api_key": AppConstants.apiKey.rawValue,
                                    "query"  : queryMovieName
                                    ]
        WebServices.hitGetAPI(parameters: param, endPoint: .movieWithName) { [weak self] json in
            let dataArray = json[ApiKey.results.rawValue].arrayValue.map{CommonMoviesResult($0)}
            self?.updateRemoteData(with: dataArray)
            self?.delegate?.getRemoteData(isSuccess: true, count: dataArray.count)
            printDebug(" >>> Remote Api Scucess with \(dataArray.count) values")
        } failure: { [weak self] error in
            printDebug(error.localizedDescription)
            self?.delegate?.getRemoteData(isSuccess: false, count: 0)
        }
    }
    
}
