//
//  DetailViewController.swift
//  Flicks
//
//  Created by Derrick Wong on 1/11/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit
import MBProgressHUD
import AVFoundation
import AVKit

class DetailViewController: UIViewController {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdropImage: UIImageView!
    
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var overviewLabel: UILabel!


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var recommendedView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var gradientBar: LayerContainerView!
    
    @IBOutlet weak var overviewHeader: UILabel!
    @IBOutlet weak var recommendedHeader: UILabel!
    
    var imageHeight: CGFloat = 0.0
    
    var movie: NSDictionary! //movie passed through segue
    var movieDetails: NSDictionary? //movie details from the api request
    
    var recomendedMovies: [NSDictionary]?
    
    var trailerUrl: URL?

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeWhite()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)

        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Poppins-Light", size: 20)!], for: UIControlState.normal)
        
        navigationItem.backBarButtonItem = backButton

        self.scrollView.delegate = self
        self.recommendedView.dataSource = self
        self.recommendedView.delegate = self
        
        flowLayout.scrollDirection = .horizontal
        
        
        imageHeight = self.backdropImage.frame.height
        
//        print("original image height: \(imageHeight)")
        
        self.titleLabel.textColor = UIColor.white
        self.overviewLabel.textColor = UIColor.white

        
        //get the movie id
        let movieId = movie["id"] as! Int
        
        //Display HUD before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        //details is a NSDictionary defined in MovieDBClient.getDetails
        MovieDBClient.getDetails(id: movieId) { (details: NSDictionary?) in
            self.movieDetails = details
            self.detailCompletion()
            self.makeBlack()
            
        }
        
        //get recommendations
        print("getting recommendations")
        MovieDBClient.getRecommendations(id: movieId) { (recommendations: [NSDictionary]?) in
            self.recomendedMovies = recommendations
            
            //reload the collection view.
            self.recommendedView.reloadData()
        }
        
        //get trailer
        MovieDBClient.getTrailer(id: movieId) { (key: String) in
            print("key \(key)")
            let url = URL(string: "\(MovieDBClient.youtubeBaseUrl)\(key)")
            //print(url)
            
            if let url = url{
                self.trailerUrl = url
                print(self.trailerUrl)
            }
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
            let posterBaseUrl = MovieDBClient.posterBaseUrl
            
            
            
            // get the poster image
            if let backdropPath = detailsDict["backdrop_path"] as? String {
                let backdropUrl = NSURL(string: posterBaseUrl + backdropPath)
                self.backdropImage.setImageWith(backdropUrl as! URL)
            }
            
            if let posterPath = detailsDict["poster_path"] as? String {
                let posterUrl = URL(string: posterBaseUrl + posterPath)
                
                self.posterImage.setImageWith(posterUrl!)
            }
            
            
            self.posterImage.layer.masksToBounds = true
            self.posterImage.layer.cornerRadius = 5.0
            
            self.titleLabel.text = title
            self.overviewLabel.text = overview
            
            self.titleLabel.textColor = UIColor.black
            self.overviewLabel.textColor = UIColor.black
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
    //updates the header when viewDidScroll
    func updateHeaderView(){
        //print(backdropImage.frame)
        var headerRect = CGRect(x:0, y:0, width: self.view.frame.width, height: self.imageHeight)
        if(scrollView.contentOffset.y + 64) < 0{
            headerRect.origin.y = scrollView.contentOffset.y + 64
            headerRect.size.height = -(64 + scrollView.contentOffset.y) + self.imageHeight
        }
        self.backdropImage.frame = headerRect
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetails"){
            let cell = sender as! UICollectionViewCell
            let indexPath = recommendedView.indexPath(for: cell)
            let movie = recomendedMovies![indexPath!.row]
            
            let detailViewController = segue.destination as! DetailViewController
            
            // pass the movie of the cell clicked on
            detailViewController.movie = movie
        } else if(segue.identifier == "showYoutubePlayer"){
            let youtubeViewController = segue.destination as! YoutubeViewController
            youtubeViewController.youtubeVideoUrl = self.trailerUrl
        }
        
        
    }
    
    func makeWhite(){
        self.trailerButton.alpha = 0
        self.timeLabel.textColor = .white
        self.yearLabel.textColor = .white
        self.genreLabel.textColor = .white
        self.ratingLabel.textColor = .white
        self.titleLabel.textColor = .white
        self.overviewLabel.textColor = .white
        self.gradientBar.alpha = 0.0
        self.overviewHeader.alpha = 0
        self.recommendedHeader.alpha = 0
    }
    
    func makeBlack(){
        self.trailerButton.alpha = 1
        self.timeLabel.textColor = .black
        self.yearLabel.textColor = .black
        self.genreLabel.textColor = .black
        self.titleLabel.textColor = .black
        self.overviewLabel.textColor = .black
        self.gradientBar.alpha = 1
        self.overviewHeader.alpha = 1
        self.recommendedHeader.alpha = 1
    }
}

extension DetailViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()

    }
    
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let recommendedMovies = self.recomendedMovies{
            return recommendedMovies.count
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath as IndexPath) as! MovieCollectionCell
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! MovieCollectionCell
        let movie = recomendedMovies![indexPath.row]
        cell.movie = movie
        
        return cell
    }
}
