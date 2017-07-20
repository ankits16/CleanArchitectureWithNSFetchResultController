//
//  MoviesAPITests.swift
//  TMDB
//
//  Created by ankit on 16/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest
@testable import TMDB

class MoviesAPITests: XCTestCase {
    
    // MARK: - Subject under test
    var sut: MoviesAPI!
    var testMovies: [Movie]!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupMoviesAPI()
    {
        sut = MoviesAPI()
        testMovies = [Seeds.Movies.movie1, Seeds.Movies.movie2]
        
        for movie in testMovies {
            let expect = expectation(description: "Wait for createMovies() to return")
            sut.createMovie(movieToCreate: movie, completionHandler: { (movieStoreResult) in
                expect.fulfill()
            })
            waitForExpectations(timeout: 1.0)
        }
    }
    
    // MARK: - Test CRUD operations
    func testFetchMoviesShouldReturnListOfMovies(){
    }
    
    func testFetchMoviesShouldReturnError(){
    }

}
