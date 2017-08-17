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
    
    @IBOutlet weak var posterView: UIImageView!

    @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    
    
    var movie: NSDictionary!{
        didSet{
            let title = movie["title"] as! String
            let rating = movie["vote_average"] as! Float
            let releaseDate = movie["release_date"] as! String
            
            //format the date to just be the year
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: releaseDate)
            dateFormatter.dateFormat = "yyyy"
            let dateText = dateFormatter.string(from: date!)
            
            
            ratingLabel.text = "\(rating)/10"
            ratingLabel.textColor = UIColor.white
            
            //set the background color
            var color: UIColor
            if rating > 8{
                color = UIColor.green
            } else if rating > 6.5 {
                color = UIColor.orange
            } else{
                color = UIColor.red
            }
            
            ratingLabel.layer.backgroundColor = color.cgColor
            ratingLabel.layer.cornerRadius = 5.0       
            
            
            
            
            self.titleLabel.text = title
            
            self.dateLabel.text = dateText


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
