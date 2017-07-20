//
//  MoviesCoreDataStoreTests.swift
//  TMDB
//
//  Created by ankit on 16/07/17.
//  Copyright © 2017 test. All rights reserved.
//


import XCTest
@testable import TMDB

class MoviesCoreDataStoreTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: MoviesCoreDataStore!
    var testMovies: [Movie]!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupMoviesCoreDataStore()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupMoviesCoreDataStore()
    {
        sut = MoviesCoreDataStore()
        deleteAllMoviesInOrdersCoreDataStore()
        testMovies = [Seeds.Movies.movie1, Seeds.Movies.movie2]
        
        for movie in testMovies {
            let expect = expectation(description: "Wait for createMovies() to return")
            sut.createMovie(movieToCreate: movie, completionHandler: { (movieStoreResult) in
                expect.fulfill()
            })
            waitForExpectations(timeout: 1.0)
        }
    }
    func deleteAllMoviesInOrdersCoreDataStore()
    {
        var allmovies = [Movie]()
        let fetchMoviesExpectation = expectation(description: "Wait for fetchMovies() to return")
        sut.fetchMovies(pageNuber: 0) { (movieStoreResult : MoviesStoreResult<[Movie]>) in
            switch (movieStoreResult){
            case .Success(let returnedMovies):
                allmovies = returnedMovies
            case .Failure(let error) :
                allmovies = [Movie]()
            }
            fetchMoviesExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        for aMovie in allmovies {
            let deleteOrderExpectation = expectation(description: "Wait for deleteOrder() to return")
            self.sut.deleteMovie(movieID: aMovie.moveID, completionHandler: { (result : MoviesStoreResult<Movie>) in
                deleteOrderExpectation.fulfill()
            })
            waitForExpectations(timeout: 1.0)
        }
    }
    
    // MARK: - Test CRUD operations
    func testFetchMoviesShouldReturnListOfMovies(){
        // given
        //when
        var fetchedMovies = [Movie]()
        var fetchMoviesError: MoviesStoreError?
        let expect = expectation(description: "Wait for fetchMovies() to return")
        
        sut.fetchMovies(pageNuber: 0) { (movieStoreResult : MoviesStoreResult<[Movie]>) in
            switch (movieStoreResult){
            case .Success(let returnedMovies):
                fetchedMovies = returnedMovies
            case .Failure(let error) :
                fetchMoviesError = error
            }
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        //then
        XCTAssertEqual(fetchedMovies.count, testMovies.count, "fetchMovies() should return a list of movies")
        for aMovie in fetchedMovies {
            XCTAssert(testMovies.contains(aMovie), "Fetched movies should match the movies in the data store")
        }
        XCTAssertNil(fetchMoviesError, "fetchMovies() should not return an error")
    }
    
    func testCreateMovieShouldCreateNewMovie(){
        // Given
        let movieToCreate = Seeds.Movies.movie3
        
        // When
        var createdMovie: Movie?
        var creatMovieError:MoviesStoreError?
        let createMovieExpectation = expectation(description: "Wait for createmovie() to return")
        sut.createMovie(movieToCreate: movieToCreate) { (result: MoviesStoreResult<Movie>) -> Void in
            switch (result) {
            case .Success(let returnedMovie):
                createdMovie = returnedMovie
            case .Failure(let error):
                creatMovieError = error
                XCTFail("createOrder() should not return an error: \(error)")
            }
            createMovieExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertEqual(createdMovie, movieToCreate, "createOrder() should create a new order")
        XCTAssertNil(creatMovieError, "createOrder() should not return an error")

    }
}
