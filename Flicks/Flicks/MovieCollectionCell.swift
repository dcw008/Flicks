//
//  MovieCollectionCell.swift
//  Flicks
//
//  Created by Derrick Wong on 8/30/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    var movie: NSDictionary!{
        didSet{
            if let posterPath = movie["poster_path"] as? String {
                let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
                let posterUrl = NSURL(string: posterBaseUrl + posterPath)
                self.posterImage.setImageWith(posterUrl as! URL)
                self.posterImage.layer.masksToBounds = true
                self.posterImage.layer.cornerRadius = 5.0
            }
        }
    }
}
