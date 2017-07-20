//
//  APICommandGeneratorTests.swift
//  TMDB
//
//  Created by ankit on 15/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest

@testable import TMDB

class APICommandGeneratorTests: XCTestCase {
    
    static let mockBaseURL = "https://mockBaseURL.org/version/movie/"
    static let fakeSecretKey = "fakeSecretKey"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    // MARK: - Test doubles
    struct MockBaseURLProvider : BaseURLStringProvider {
        func fetchBaseURLString() -> String {
            return APICommandGeneratorTests.mockBaseURL
        }
    }
    struct MockSecretKeyReader : SecretKeyReader {
        func fetchSecretKey() -> String {
            return APICommandGeneratorTests.fakeSecretKey
        }
    }
    
    func testPopularCommandGenerator()  {
        let baseURLProvider = MockBaseURLProvider()
        let secretKeyReader = MockSecretKeyReader()
        let apiCommandGenerator = APICommandGenerator(baseURLProvider: baseURLProvider, secretKeyReader: secretKeyReader)
        let generatedPopularCommand = apiCommandGenerator.popularCommandGenerator(pageNumber: 1)
        let expectedPopularCommand = "https://mockBaseURL.org/version/movie/popular?api_key=fakeSecretKey&language=en-US&page=1"
        XCTAssertTrue(generatedPopularCommand == expectedPopularCommand, "Correct Popular command should be generated.")
    }
    

}
