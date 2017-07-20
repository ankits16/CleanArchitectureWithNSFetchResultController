//
//  MovieListInteractorTests.swift
//  TMDB
//
//  Created by ankit on 15/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest

@testable import TMDB

class MovieListInteractorTests: XCTestCase {
    // MARK: - Subject under test
    
    var sut: MovieListInteractor!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupMovieListInteractor()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func wait(duration: TimeInterval) {
        let expect = expectation(description: "wait")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (duration)) {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: duration + 3, handler: nil)
    }
    
    // MARK: - Test setup
    
    func setupMovieListInteractor()
    {
        sut = MovieListInteractor()
    }
    
    // MARK: - Test doubles
    class MovieListAPIWorkerSpy: MovieListWorker{
        // MARK: Method call expectations
         var fetchMoviesCalled = false
        // MARK: Spied methods
        override func fetchMovies(pageNuber : Int,  completionHandler :  @escaping MoviesStoreFetchOrdersCompletionHandler)  {
            fetchMoviesCalled = true
            completionHandler(MoviesStoreResult.Success(result: [Seeds.Movies.movie1, Seeds.Movies.movie2]))
        }
    }
    
    class MovieListAPIErrorWorkerSpy: MovieListWorker{
        // MARK: Method call expectations
        var fetchMoviesCalled = false
        // MARK: Spied methods
        override func fetchMovies(pageNuber : Int,  completionHandler :  @escaping MoviesStoreFetchOrdersCompletionHandler) {
            fetchMoviesCalled = true
            let error = MoviesStoreError.CannotFetch("Dummy Error")
            completionHandler(MoviesStoreResult.Failure(error: error))
        }
    }
    
    class MovieListPresentationLogicSpy: MovieListPresentationLogic{
       // MARK: Method call expectations
        var presentFetchedMoviesCalled = false
        var presentInsertedMoviesCalled = false
        // MARK: Argument expectations
        var fetchedMovieResponse : MovieList.FetchMovieList.Response!
        var insertedMovieResponse : MovieList.InsertedMovie.Response!
        // MARK: Spied methods
        func presentFetchedMovies(response : MovieList.FetchMovieList.Response){
            presentFetchedMoviesCalled = true
            fetchedMovieResponse = response
        }
        func presentInsertedMovie(response : MovieList.InsertedMovie.Response){
            presentInsertedMoviesCalled = true
            insertedMovieResponse = response
        }
    }
    
    // MARK: - Tests
    
        
    func testFetchMoviesFromServer()  {
        // given
        let listPresenterSpy = MovieListPresentationLogicSpy()
        sut.presenter  = listPresenterSpy
        let movieListWorker = MovieListAPIWorkerSpy(moviesStore: MoviesAPI())
        sut.apiWorker = movieListWorker
        
        // when
        let request = MovieList.FetchMovieList.Request(pageNumber: 10)
        sut.fetchMovieListFromServer(request: request)
        
        // then
        XCTAssertTrue(movieListWorker.fetchMoviesCalled, "Fetch movies should be called")
        XCTAssertNil(listPresenterSpy.fetchedMovieResponse, "Error should be nil while fetching the movies")
    }
    func testFetchMoviesErrorFromServer()  {
        // given
        let listPresenterSpy = MovieListPresentationLogicSpy()
        sut.presenter  = listPresenterSpy
        let movieListWorker = MovieListAPIErrorWorkerSpy(moviesStore: MoviesAPI())
        sut.apiWorker = movieListWorker
        
        // when
        let request = MovieList.FetchMovieList.Request(pageNumber: 10)
        sut.fetchMovieListFromServer(request: request)
        
        // then
        XCTAssertTrue(movieListWorker.fetchMoviesCalled, "Fetch movies should be called")
        XCTAssertNotNil(listPresenterSpy.fetchedMovieResponse.error, "Error should not be nil while fetching the movies")
    }
    func testInsertMovieToMainContext(){
        //given
        let listPresenterSpy = MovieListPresentationLogicSpy()
        sut.presenter  = listPresenterSpy
        let movieListWorker = MovieListAPIWorkerSpy(moviesStore: MoviesCoreDataStore())
        sut.storeWorker = movieListWorker
        //when
        sut.saveFetchedMoviesToStore(fetchedMovies: [Seeds.Movies.movie1])
        wait(duration: 1.0)
        //then
        XCTAssertTrue(listPresenterSpy.presentInsertedMoviesCalled, "Inserted moive should be presented")
        XCTAssertTrue(listPresenterSpy.insertedMovieResponse.formatteMovie == Seeds.Movies.movie1, "Expected movie should be inserted.")
    }
    func testApplyFilterPredicate() {
        
    }

    
}
