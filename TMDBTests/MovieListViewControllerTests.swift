//
//  MovieListViewControllerTests.swift
//  TMDB
//
//  Created by ankit on 15/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest

@testable import TMDB

class MovieListViewControllerTests: XCTestCase {
    // MARK: - Subject under test
    var sut: MovieListViewController!
    var window: UIWindow!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupMovieListViewController()
        
    }
    override func tearDown()
    {
        window = nil
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
    
    func setupMovieListViewController(){
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
        UIApplication.shared.keyWindow!.rootViewController = sut
        sut.preloadView()
    }
    
    func loadView(){
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
     // MARK: - Test doubles
    class MovieListBusinessLogicSpy: MovieListBusinessLogic , MovieListDataStore {
        // MARK: Method call expectations
        var fetchMovieListCalled = false
        // MARK: Argument expectations
        var fetchMovieListRequest : MovieList.FetchMovieList.Request!
        // MARK: Spied variables
        // MARK: Spied methods
        func fetchMovieListFromServer(request : MovieList.FetchMovieList.Request){
            fetchMovieListCalled = true
            fetchMovieListRequest = request
        }
        func applyPredicateToMovieList(request : MovieList.ApplyPredicate.Request){
            
        }
        func numberOfMovies() -> NSInteger{
            return 0
        }
        func movieAt(indexpath : IndexPath) -> Movie? {
            return nil
        }
        func posterImageForMovie(url: URL , completionHandler: @escaping ImageFetchCompletionHandler){
            
        }
    }

    // MARK: tests
    func testFetchMovies() {
        // Given
        let movieListBusinessLogicSpy = MovieListBusinessLogicSpy()
        sut.interactor = movieListBusinessLogicSpy as! (MovieListBusinessLogic & MovieListDataStore)
        
        // When
        sut.currentPage = 2
        // Then
        
        XCTAssertTrue(movieListBusinessLogicSpy.fetchMovieListCalled, "Fetch movie list should be called.")
        XCTAssertTrue(movieListBusinessLogicSpy.fetchMovieListRequest.pageNumber == 2, "Fetch movie list should be called for current page.")
    }
    func testDisplayFetchedError()  {
        //given
        let viewModel = MovieList.FetchMovieList.ViewModel(errorMsg: "Dummy Error")
        //when
        sut.displayFetchedError(viewModel: viewModel)
        self.wait(duration: 1)
        //then
        let presentedVC = sut.presentedViewController as! UIAlertController
        XCTAssertTrue(presentedVC.title == "Error" , "Error should be displayed")
        XCTAssertTrue(presentedVC.message == "Dummy Error" , "Expected error message should be displayed")
    }
    func testGenerateFilter(){
        
    }
}


extension UIViewController {
    func preloadView() {
        let _ = view
    }
}
