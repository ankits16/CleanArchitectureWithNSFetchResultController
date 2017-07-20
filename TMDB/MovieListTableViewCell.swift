//
//  MovieListTableViewCell.swift
//  TMDB
//
//  Created by ankit on 17/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    @IBOutlet var titleLBL : UILabel?
    @IBOutlet var releaseDateLBL : UILabel?
    @IBOutlet var ratingLBL : UILabel?
    @IBOutlet var posterImageView : UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
