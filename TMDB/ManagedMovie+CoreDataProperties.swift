//
//  ManagedMovie+CoreDataProperties.swift
//  TMDB
//
//  Created by ankit on 16/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
import CoreData


extension ManagedMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedMovie> {
        return NSFetchRequest<ManagedMovie>(entityName: "ManagedMovie")
    }

    @NSManaged public var title: String?
    @NSManaged public var movieID: Int64
    @NSManaged public var rating: Float
    @NSManaged public var releaseYear: Int64
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var createdTimeStamp: NSDate?
    @NSManaged public var posterPath: String?
    @NSManaged public var backdropPath: String?
    @NSManaged public var overview: String?
    

}
