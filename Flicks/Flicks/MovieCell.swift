   //
//  MovieCell.swift
//  Flicks
//
//  Created by Derrick Wong on 1/4/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit
   
   protocol MovieCellDelegate: class {
    
   }

class MovieCell: UITableViewCell {
    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewView: UITextView!
    @IBOutlet weak var posterView: UIImageView!


    var movie: NSDictionary!{
        didSet{
            let title = movie["title"] as! String
            let overview = movie["overview"] as! String
            
//            let voteAverage = movie["vote_average"] as! Float
            
//            self.titleLabel.text = String(voteAverage)
            
            self.titleLabel.text = title
            self.overviewView.text = overview;
            self.overviewView.isEditable = false
            


            if let posterPath = movie["poster_path"] as? String {
                let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
                let posterUrl = NSURL(string: posterBaseUrl + posterPath)
                let imageRequest = NSURLRequest(url: posterUrl! as URL)
                self.posterView.setImageWith(imageRequest as URLRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) -> Void in
                        
                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            print("Image was NOT cached, fade in image")
                            self.posterView.alpha = 0.0
                            self.posterView.image = image
                            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                self.posterView.alpha = 1.0
                            })
                        } else {
                            print("Image was cached so just update the image")
                            self.posterView.image = image
                        }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
                    self.posterView.image = nil
                })
            }
            
        }
    }

    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
