//
//  MovieListPresenterTests.swift
//  TMDB
//
//  Created by ankit on 15/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest

@testable import TMDB

class MovieListPresenterTests: XCTestCase {
    // MARK: - Subject under test
    var sut: MovieListPresenter!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupMovieListPresenter()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func setupMovieListPresenter(){
        sut = MovieListPresenter()
    }
    
    // MARK: - Test doubles
    class MovieListPresenterSpy : MovieListDisplayLogic{
        // MARK: Method call expectations
        var displayFetchedErrorCalled = false
        var insertMovieRowCalled = false
        // MARK: Argument expectations
        var fetchErrorViewModel : MovieList.FetchMovieList.ViewModel!
        var insertRowViewModel : MovieList.InsertedMovie.ViewModel!
        // MARK: Spied methods
        func displayFetchedError(viewModel : MovieList.FetchMovieList.ViewModel){
            displayFetchedErrorCalled = true
            fetchErrorViewModel = viewModel
        }
        func insertMovie(viewModel: MovieList.InsertedMovie.ViewModel) {
            insertMovieRowCalled = true
            insertRowViewModel = viewModel
        }
    }
    
    // MARK: - Tests
    func testPresentFetchedMovieError()  {
        //given
        let movieListDisplayLogicSpy = MovieListPresenterSpy()
        sut.viewController = movieListDisplayLogicSpy
        let response  = MovieList.FetchMovieList.Response(error: "Dummy Error")
        //when
        sut.presentFetchedMovies(response: response)
        //then
        XCTAssertTrue(movieListDisplayLogicSpy.displayFetchedErrorCalled, "Fetched error should be called")
        XCTAssertTrue(movieListDisplayLogicSpy.fetchErrorViewModel.errorMsg == "Dummy Error", "Expected error message should be displayed")
    }
    
    func testInsertMovie()  {
        //given
        let movieListDisplayLogicSpy = MovieListPresenterSpy()
        sut.viewController = movieListDisplayLogicSpy
        let response = MovieList.InsertedMovie.Response(formatteMovie: Seeds.Movies.movie1, indexPath: IndexPath(row: 0, section: 0))
        
        //when
        sut.presentInsertedMovie(response: response)
        
        //then
        XCTAssertTrue(movieListDisplayLogicSpy.insertMovieRowCalled, "Insert new row in movie list should be called")
        XCTAssertTrue(movieListDisplayLogicSpy.insertRowViewModel.movieTitle == Seeds.Movies.movie1.title, "Expected movie should be inserted")
        XCTAssertTrue(movieListDisplayLogicSpy.insertRowViewModel.indexPath == IndexPath(row: 0, section: 0), "Movie should be inserted at expected indepath")
    }
    
}
