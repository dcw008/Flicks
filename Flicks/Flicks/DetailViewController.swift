//
//  DetailViewController.swift
//  Flicks
//
//  Created by Derrick Wong on 1/11/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdropImage: UIImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!

    var movie: NSDictionary!
    var count = 0
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        
        layer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        layer.locations = [0.7, 1.0]
        
        return layer
    } ()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        gradientLayer.frame = backdropImage.bounds

    }



    override func viewDidLoad() {
        super.viewDidLoad()

        //set title and overview
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        //set the base url
        let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
        
        
        // get the poster image
        if let backdropPath = movie["backdrop_path"] as? String {
            let backdropUrl = NSURL(string: posterBaseUrl + backdropPath)
            backdropImage.setImageWith(backdropUrl as! URL)
            backdropImage.layer.addSublayer(gradientLayer)
            gradientLayer.frame = backdropImage.bounds
 
        }
        
        titleLabel.text = title
        overviewLabel.text = overview
        
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //375 x 164

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
