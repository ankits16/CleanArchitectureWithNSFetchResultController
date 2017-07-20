//
//  ManagedMovie+CoreDataClass.swift
//  TMDB
//
//  Created by ankit on 16/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedMovie)
public class ManagedMovie: NSManagedObject {

    func toMovie() -> Movie{
        return Movie(moveID: NSNumber(value: movieID), rating: NSNumber(value: rating), title: title!, posterPath: posterPath, releaseDate: releaseDate! as Date, backdropPath: backdropPath, overview: overview)

    }
    func fromMovie(movie : Movie)  {
        movieID = Int64(movie.moveID)
        rating = Float(movie.rating)
        title = movie.title
        posterPath = movie.posterPath
        backdropPath = movie.backdropPath
        overview = movie.overview
        releaseYear = Int64(movie.releaseYear)
        releaseDate = movie.releaseDate as NSDate
        if (createdTimeStamp == nil){
            createdTimeStamp = NSDate()
        }
    }
}
