//
//  DetailViewController.swift
//  Flicks
//
//  Created by Derrick Wong on 1/11/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit
import MBProgressHUD


class DetailViewController: UIViewController {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdropImage: UIImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!


    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageHeight: CGFloat = 0.0
    
    var movie: NSDictionary! //movie passed through segue
    var movieDetails: NSDictionary? //movie details from the api request

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        //offset = -self.scrollView.contentOffset.y
        
        imageHeight = self.backdropImage.frame.height
        
        print("original image height: \(imageHeight)")
        
        self.titleLabel.textColor = UIColor.white
        self.overviewLabel.textColor = UIColor.white

        
        //get the movie id
        let movieId = movie["id"] as! Int
        
        //Display HUD before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        //call method for api request with completion block
        request(id: movieId, completion: {
            
            if let detailsDict = self.movieDetails {
                //set the ui elements on the main thread.
                let title = detailsDict["title"] as! String
                let overview = detailsDict["overview"] as! String
                
                var genres = [""]
                
                for genre in (detailsDict["genres"] as! [NSDictionary]){
                    genres.append(genre["name"] as! String)
                }
                
                
                
                //set the base url
                let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
                
                
                // get the poster image
                if let backdropPath = detailsDict["backdrop_path"] as? String {
                    let backdropUrl = NSURL(string: posterBaseUrl + backdropPath)
                    self.backdropImage.setImageWith(backdropUrl as! URL)
                }
                
                self.titleLabel.text = title
                self.overviewLabel.text = overview
                
                self.titleLabel.textColor = UIColor.black
                self.overviewLabel.textColor = UIColor.black
                
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        })
        
        
        
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //makes a network request to detailed information about the movie
    func request(id: Int, completion: @escaping () -> Void){
        
        //Network api request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)")
        print("https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=en-US")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            // ... Use the new data to update the data source ...
            if let data = dataOrNil{
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //print(responseDictionary)
                    self.movieDetails = responseDictionary
                    
                    DispatchQueue.main.async {
                        //change the UI on the main thread
                        completion()
                    }
                    
                }
            }
        })
        task.resume()

    }
    
    //updates the header
    func updateHeaderView(){
        print(backdropImage.frame)
        var headerRect = CGRect(x:0, y:0, width: self.view.frame.width, height: self.imageHeight)
        if(scrollView.contentOffset.y + 64) < 0{
            headerRect.origin.y = scrollView.contentOffset.y + 64
            headerRect.size.height = -(64 + scrollView.contentOffset.y) + self.imageHeight
            
            
        }
        self.backdropImage.frame = headerRect
    }
}

extension DetailViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        updateHeaderView()
      
        
    }
    
}
