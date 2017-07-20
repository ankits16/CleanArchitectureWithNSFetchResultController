//
//  MovieDetailTableViewController.swift
//  TMDB
//
//  Created by ankit on 18/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController {
    
    var targetMovie : Movie?
    @IBOutlet var movieTitleLBL : UILabel?
    @IBOutlet var yearLBL : UILabel?
    @IBOutlet var ratingLBL : UILabel?
    @IBOutlet var descriptionTxt : UILabel?
    @IBOutlet var topPosterImageView : UIImageView?
    @IBOutlet var bottomPosterImageView : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitleLBL?.text = targetMovie?.title
        yearLBL?.text = String((targetMovie?.releaseYear)!)
        ratingLBL?.text = String(((targetMovie?.rating)?.floatValue)!)
        descriptionTxt?.text = targetMovie?.overview
        if let unwrappedBottomPosterURL = targetMovie?.posterURL{
            PosterImageWorker().fetchImage(url: unwrappedBottomPosterURL, completionHandler: { (result : ImageFetchResult<UIImage>) in
                switch (result) {
                case .Success(let image) :
                    DispatchQueue.main.async {
                        self.bottomPosterImageView?.image = image
                    }
                case .Failure(let error) :
                    print(error.localizedDescription)
                }

            })
        }
        if let unwrappedBackDropURL = targetMovie?.backDropURL{
            PosterImageWorker().fetchImage(url: unwrappedBackDropURL, completionHandler: { (result : ImageFetchResult<UIImage>) in
                switch (result) {
                case .Success(let image) :
                    DispatchQueue.main.async {
                        self.topPosterImageView?.image = image
                    }
                case .Failure(let error) :
                    print(error.localizedDescription)
                }
                
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
