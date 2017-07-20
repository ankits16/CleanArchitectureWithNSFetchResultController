//
//  PosterImageWorker.swift
//  TMDB
//
//  Created by ankit on 17/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
import UIKit

class PosterImageWorker {
    
    var activeImageDownloads = [URL :  ImageFetchCompletionHandler]()
    let cache = NSCache<NSString, UIImage>()
    
    lazy var imageDownloadSession: URLSession = {
        var configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }()

    
    func fetchImage(url : URL , completionHandler : @escaping ImageFetchCompletionHandler) {
        if let cahcedImage = queryCache(url: url){
            completionHandler(ImageFetchResult.Success(result: cahcedImage))
        }else{
            if (activeImageDownloads[url] == nil){
                activeImageDownloads[url] = completionHandler
                let task = imageDownloadSession.dataTask(with: url, completionHandler: { (data, response, error) in
                    if (error != nil){
                        completionHandler(ImageFetchResult.Failure(error: ImageFetchError.CannotFetch((error?.localizedDescription)!)
                        )
                        )
                    }else{
                        if let unwrappedData = data {
                            if let fetchedImage = UIImage(data: unwrappedData){
                                //save to cache
                                self.saveImageToCache(fetchedImage, forKey: url.absoluteString)
                                completionHandler(ImageFetchResult.Success(result: fetchedImage))
                                
                            }else{
                                completionHandler(ImageFetchResult.Failure(error: ImageFetchError.NotImage()))
                            }
                            
                        }else{
                            completionHandler(ImageFetchResult.Failure(error: ImageFetchError.NotData()))
                        }
                        
                    }
                })
                task.resume()
                
                
            }else{
                
            }
        }
        
    }
    
    func queryCache(url : URL) -> UIImage? {
        if let existingImage = cache.object(forKey: url.absoluteString as NSString) {
            return existingImage
        }
        return nil
    }
    
    func saveImageToCache(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        // Turn image into JPEG data
    }
    
}

typealias ImageFetchCompletionHandler = (ImageFetchResult<UIImage>) -> Void

enum ImageFetchResult<U>
{
    case Success(result: U)
    case Failure(error: ImageFetchError)
}

enum ImageFetchError: Equatable, Error
{
    case CannotFetch(String)
    case NotData()
    case NotImage()
}

func ==(lhs: ImageFetchError, rhs: ImageFetchError) -> Bool
{
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    
    default: return false
    }
}
