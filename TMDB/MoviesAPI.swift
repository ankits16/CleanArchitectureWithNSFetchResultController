//
//  MoviesAPI.swift
//  TMDB
//
//  Created by ankit on 16/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation

class MoviesAPI: MoviesStoreProtocol {
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    func fetchMovies(pageNuber : Int, completionHandler: @escaping MoviesStoreFetchOrdersCompletionHandler){
        let urlStr = APICommandGenerator(baseURLProvider: APIBase(), secretKeyReader: SecretKey()).popularCommandGenerator(pageNumber: pageNuber)
        let postData =  "{}".data(using: .utf8)
        
        var request = URLRequest(url: URL(string: urlStr)!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                let error = MoviesStoreError.CannotFetch((error?.localizedDescription)!)
                completionHandler(MoviesStoreResult.Failure(error: error))
            } else {
                let httpResponse = response as? HTTPURLResponse
                if let fetchedData = data{
                    do {
                        if let fetchedJSON = try JSONSerialization.jsonObject(with:fetchedData, options: .mutableLeaves) as? [String : Any]{
                            if (httpResponse?.statusCode == 200){
                                if let fetchedMovies = fetchedJSON["results"] as? [[String : Any]]{
                                    var movies = [Movie]()
                                    for aMovieDict in fetchedMovies{
                                        let movieID = aMovieDict ["id"] as! NSNumber
                                        let rating = aMovieDict ["vote_average"] as! NSNumber
                                        let title = aMovieDict ["title"] as! String
                                        let posterPath = aMovieDict ["poster_path"] as! String
                                        let backdropPath = aMovieDict ["backdrop_path"] as! String
                                        let overview = aMovieDict ["overview"] as! String
                                        let releaseDate = self.dateFormatter.date(from: aMovieDict ["release_date"] as! String)
                                        let aMovie = Movie(moveID: movieID, rating: rating, title: title , posterPath: posterPath , releaseDate: releaseDate!, backdropPath: backdropPath , overview : overview )
                                        movies.append(aMovie)
                                    }
                                    completionHandler(MoviesStoreResult.Success(result: movies))
                                    
                                    
                                }else{
                                    let error = MoviesStoreError.CannotFetch("Fetch Movie Data in unknown format")
                                    completionHandler(MoviesStoreResult.Failure(error: error))
                                }
                                
                                
                                
                            }else{
                                if let error  = (fetchedJSON["errors"] as? [String])?.first{
                                    let error = MoviesStoreError.CannotFetch(error)
                                    completionHandler(MoviesStoreResult.Failure(error: error))
                                }else{
                                    let error = MoviesStoreError.CannotFetch("Fetch Movie Data in unknown format")
                                    completionHandler(MoviesStoreResult.Failure(error: error))
                                }
                            }
                            
                        }else{
                            let error = MoviesStoreError.CannotFetch("Fetch Movie Data in unknown format")
                            completionHandler(MoviesStoreResult.Failure(error: error))
                        }
                        
                    }catch let error {
                        let error = MoviesStoreError.CannotFetch(error.localizedDescription)
                        completionHandler(MoviesStoreResult.Failure(error: error))
                    }
                    
                }else{
                    let error = MoviesStoreError.CannotFetch("API Error")
                    completionHandler(MoviesStoreResult.Failure(error: error))
                }
            }
        })
        
        dataTask.resume()
        
    }
    func createMovie(movieToCreate: Movie, completionHandler: @escaping MoviesStoreCreateOrderCompletionHandler){
        
    }
    func deleteMovie(movieID: NSNumber, completionHandler: @escaping MoviesStoreDeleteOrderCompletionHandler){
        
    }
}
