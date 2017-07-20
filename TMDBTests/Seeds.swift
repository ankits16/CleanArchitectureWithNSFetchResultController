//
//  Seeds.swift
//  TMDB
//
//  Created by ankit on 16/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation

@testable import TMDB

struct Seeds {
    struct Movies{
        static let movie1 = Movie(moveID: 1, rating: 1, title: "Dummy 1", posterPath: "DummyPosterPath1", releaseDate: Date(), backdropPath: "bd1.png", overview: "over")
        static let movie2 = Movie(moveID: 2, rating: 2, title: "Dummy 2", posterPath: "DummyPosterPath2", releaseDate: Date(), backdropPath: "bd1.png", overview: "over")
        static let movie3 = Movie(moveID: 3, rating: 3, title: "Dummy 3", posterPath: "DummyPosterPath3", releaseDate: Date(), backdropPath: "bd1.png", overview: "over")
    }
}
