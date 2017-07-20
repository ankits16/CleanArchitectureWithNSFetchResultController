//
//  MovieTest.swift
//  TMDB
//
//  Created by ankit on 17/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest

@testable import TMDB

class MovieTest: XCTestCase {
    
    // MARK: - Subject under test
    var sut: Movie!
    
    var movieID = NSNumber(value: 22)
    var movieTitle = "Dummy Title"
    var posterPath = "/xu9zaAevzQ5nnrsXN6JcahLnG4i.jpg"
    var releaseYear = 1987
    var releaseMonth = 03
    var releaseDay = 16
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupMovie()
    }
    
    func setupMovie(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let releaseDate = dateFormatter.date(from: "1987-03-16")
        sut = Movie(moveID: movieID, rating: 1, title: movieTitle, posterPath: posterPath, releaseDate: releaseDate!, backdropPath: "bd1", overview : "overview")
    
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    //MARK:- test
    
    func testCreatedMovie()  {
        XCTAssertTrue(sut.moveID == movieID, "Movie ID should be same")
        XCTAssertTrue(sut.title == movieTitle, "Movie title should be same")
        XCTAssertTrue(sut.posterURL?.absoluteString == "https://image.tmdb.org/t/p/w500/xu9zaAevzQ5nnrsXN6JcahLnG4i.jpg", "Expected  poster path should be generated.")
        XCTAssertTrue(sut.releaseYear == 1987, "Expected release year should be generated")
    }
    
}
