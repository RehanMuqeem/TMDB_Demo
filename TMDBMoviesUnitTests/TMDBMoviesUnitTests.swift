//
//  TMDBMoviesUnitTests.swift
//  TMDBMoviesUnitTests
//
//  Created by appinventiv on 29/12/22.
//

import XCTest
@testable import TMDBMovies ///import module of the project like this to get access of the project files.

//MARK: - Writing Unit test cases for the movie detail screen

final class TMDBMoviesUnitTests: XCTestCase {
    
    var viewModel: MovieDetailVM!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = MovieDetailVM(movieId: 76600)
        // id for movie - "Avatar: The Way of Water"
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.viewModel = nil
        try super.tearDownWithError()
    }
    
    func testRemoteData() {
        let remoteData = self.viewModel.getMovieData()
        let expectedData = MovieDetailDataModel()
        XCTAssertEqual(expectedData, remoteData, "Remote data is wrong")
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
