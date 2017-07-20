//
//  Movie.swift
//  TMDB
//
//  Created by ankit on 15/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation

struct Movie : Equatable {
    var moveID : NSNumber
    var rating : NSNumber
    var title : String
    var posterPath : String?
    var releaseDate : Date
    var backdropPath: String?
    var overview: String?
    
    var posterURL : URL? {
        get {
            if let unwrappedPosterPath = posterPath{
                return  URL(string: "https://image.tmdb.org/t/p/w500" + unwrappedPosterPath)
            }
            return nil
        }
    }
    var backDropURL : URL? {
        get {
            if let unwrappedBackdropPath = backdropPath{
                return  URL(string: "https://image.tmdb.org/t/p/w500" + unwrappedBackdropPath)
            }
            return nil
        }
    }
    var releaseYear : Int {
        get {
            let calendar = Calendar.current
            return calendar.component(.year, from: releaseDate)
        }
    }
}

func ==(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.moveID == rhs.moveID
}

