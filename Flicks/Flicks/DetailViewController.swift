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
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var recommendedView: UICollectionView!
    var imageHeight: CGFloat = 0.0
    
    var movie: NSDictionary! //movie passed through segue
    var movieDetails: NSDictionary? //movie details from the api request
    
    var recomendedMovies: [NSDictionary]?

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        //self.recommendedView.dataSource = self
        
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
//        detailRequest(id: movieId, completion: {
//            
//           self.detailCompletion()
//        })
        
        //details is a NSDictionary defined in MovieDBClient.getDetails
        MovieDBClient.getDetails(id: movieId) { (details: NSDictionary?) in
            self.movieDetails = details
            self.detailCompletion()
            
        }
        
        
        
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //completion block for requesting movie details
    //sets the UI elements
    func detailCompletion(){
        if let detailsDict = self.movieDetails {
            //set the ui elements on the main thread.
            let title = detailsDict["title"] as! String
            let overview = detailsDict["overview"] as! String
            
            let rating = detailsDict["vote_average"] as! Float
            
            let time = detailsDict["runtime"] as! Int
            let timeInHrs = time/60
            let timeInMin = time % 60
            let releaseDate = detailsDict["release_date"] as! String
            
            //format the date to just be the year
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: releaseDate)
            dateFormatter.dateFormat = "MMMM d, yyyy"
            
            
            let dateText = dateFormatter.string(from: date!)
            self.yearLabel.text = dateText
            
            self.timeLabel.text = "\(timeInHrs) hrs \(timeInMin) min"
            
            self.ratingLabel.text = " \(rating)/10 "
            self.ratingLabel.textColor = UIColor.white
            
            //set the background color
            var color: UIColor
            if rating > 8{
                color = UIColor.green
            } else if rating > 6.5 {
                color = UIColor.orange
            } else{
                color = UIColor.red
            }
            
            self.ratingLabel.layer.backgroundColor = color.cgColor
            self.ratingLabel.layer.cornerRadius = 5.0
            
            
            var genres = [""]
            genres.removeAll()
            
            for genre in (detailsDict["genres"] as! [NSDictionary]){
                genres.append(genre["name"] as! String)
            }
            
            
            self.genreLabel.text = genres.joined(separator: ", ")
            
            
            //set the base url
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            
            
            // get the poster image
            if let backdropPath = detailsDict["backdrop_path"] as? String {
                let backdropUrl = NSURL(string: posterBaseUrl + backdropPath)
                self.backdropImage.setImageWith(backdropUrl as! URL)
            }
            
            if let posterPath = detailsDict["poster_path"] as? String {
                let posterUrl = URL(string: posterBaseUrl + posterPath)
                
                self.posterImage.setImageWith(posterUrl!)
            }
            
            
            
            self.titleLabel.text = title
            self.overviewLabel.text = overview
            
            self.titleLabel.textColor = UIColor.black
            self.overviewLabel.textColor = UIColor.black
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    

    
//    //makes a network request to detailed information about the movie
//    func detailRequest(id: Int, completion: @escaping () -> Void){
//        
//        
//        //Network api request
//        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)")
//        
//        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
//        
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
//        
//        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
//            // ... Use the new data to update the data source ...
//            if let data = dataOrNil{
//                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
//                    //print(responseDictionary)
//                    self.movieDetails = responseDictionary
//                    
//                    DispatchQueue.main.async {
//                        //change the UI on the main thread
//                        completion()
//                    }
//                    
//                }
//            }
//        })
//        task.resume()
//
//    }
    
//    func recommendedRequest(id: Int, completion: @escaping () -> Void){
//        
//        
//        //Network api request
//        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/recommendations?api_key=\(apiKey)")
//        
//        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
//        
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
//        
//        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
//            // ... Use the new data to update the data source ...
//            if let data = dataOrNil{
//                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? [NSDictionary] {
//                    //print(responseDictionary)
//                    self.recomendedMovies = responseDictionary
//                    
//                    DispatchQueue.main.async {
//                        //change the UI on the main thread
//                        completion()
//                    }
//                    
//                }
//            }
//        })
//        task.resume()
//        
//    }
    
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

//extension DetailViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    
//}
