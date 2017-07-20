//
//  MoviesCoreDataStore.swift
//  TMDB
//
//  Created by ankit on 16/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import CoreData

class MoviesCoreDataStore : MoviesStoreProtocol{
    
    // MARK: - Managed object contexts
    public var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    
    // MARK: - Object lifecycle
    
    init()
    {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Movies", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("Movies.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
    }
    func saveToDisk()  {
       /* do {
            try self.mainManagedObjectContext.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }*/
    }
    
    
    deinit
    {
        do {
            try self.mainManagedObjectContext.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
     // MARK: - CRUD operations - Optional error
    func fetchMovies(pageNuber : Int, completionHandler: @escaping MoviesStoreFetchOrdersCompletionHandler){
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedMovie")
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedMovie]
                let movies = results.map { $0.toMovie() }
                completionHandler(MoviesStoreResult.Success(result: movies))
            } catch {
                let error = MoviesStoreError.CannotFetch("Unable to fetch movies")
                completionHandler(MoviesStoreResult.Failure(error: error))
            }
        }
    }
    
    func createMovie(movieToCreate: Movie, completionHandler: @escaping MoviesStoreCreateOrderCompletionHandler){
        privateManagedObjectContext.perform {
            do {
                let managedOrder = NSEntityDescription.insertNewObject(forEntityName: "ManagedMovie", into: self.privateManagedObjectContext) as! ManagedMovie
                managedOrder.fromMovie(movie: movieToCreate)
                try self.privateManagedObjectContext.save()
                completionHandler(MoviesStoreResult.Success(result: movieToCreate))
            } catch {
                let error = MoviesStoreError.CannotCreate("Cannot create order with id \(String(describing: movieToCreate.moveID))")
                completionHandler(MoviesStoreResult.Failure(error: error))
            }
        }
    }
    
    func deleteMovie(movieID: NSNumber, completionHandler: @escaping MoviesStoreDeleteOrderCompletionHandler){
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedMovie")
                fetchRequest.predicate = NSPredicate(format: "movieID == %@", movieID)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedMovie]
                if let managedMovie = results.first {
                    let movie = managedMovie.toMovie()
                    self.privateManagedObjectContext.delete(managedMovie)
                    do {
                        try self.privateManagedObjectContext.save()
                        completionHandler(MoviesStoreResult.Success(result: movie))
                       
                    } catch {
                        let error = MoviesStoreError.CannotDelete("Cannot delete order with id \(movieID)")
                        completionHandler(MoviesStoreResult.Failure(error: error))
                        
                    }
                } else {
                    let error = MoviesStoreError.CannotDelete("Cannot delete order with id \(movieID)")
                    completionHandler(MoviesStoreResult.Failure(error: error))
                }
            } catch {
                let error = MoviesStoreError.CannotDelete("Cannot delete order with id \(movieID)")
                completionHandler(MoviesStoreResult.Failure(error: error))
            }
        }
    }


}
