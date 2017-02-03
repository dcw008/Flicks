
//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Derrick Wong on 1/2/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //outlet to the table view
    @IBOutlet weak var tableView: UITableView!
    
    //outlet to the search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //array of dictionaries that represent each movie
    var movies: [NSDictionary]?
    
    //an array that keeps track of filtered data based on search bar field
    var filteredData: [NSDictionary]!
    
    //keeps track endpoint of the api url
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        
        //self.tableView.frame = UIScreen.main.bounds
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        //set the delegate
        searchBar.delegate = self
        
        //initialize filteredData to default data
        filteredData = movies
        


        //Network api request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //Display HUD before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        

        //set the task
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = dataOrNil {
                
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //print("response: \(responseDictionary)")
                    
                    //load the data then update filteredData
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.filteredData = self.movies
                    self.tableView.reloadData()
                    

                    
                }
            }
            
        })
        task.resume()
    
    }
    
    //deselects the gray area after user pushes on the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //deselect of the gray cell
        tableView.deselectRow(at: indexPath, animated:true)
    }


    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        //Network api request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let myRequest = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: myRequest, completionHandler: { (data, response, error) in
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
                                                                        
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        });
        task.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let filteredData = filteredData {
            return filteredData.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        // index path tells the cell where it is in the tableView
        
        let cell = tableView.dequeueReusableCell( withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredData![indexPath.row]
        cell.movie = movie
//        let title = movie["title"] as! String
//        let overview = movie["overview"] as! String
//        
//        cell.titleLabel.text = title;
//        cell.overviewLabel.text = overview;
//        
//        if let posterPath = movie["poster_path"] as? String {
//            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
//            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
//            cell.posterView.setImageWith(posterUrl as! URL)
//        }
//        else {
//            // No poster image. Can either set to nil (no image) or a default movie poster image
//            // that you include as an asset
//            cell.posterView.image = nil
//        }
//        
        return cell
    }

    //This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         //When there is no text, filteredData is the same as the original data
         //When user has entered text into the search box
         //Use the filter method to iterate over all items in the data array
         //For each item, return true if the item should be included and false if the
         //item should NOT be included
            filteredData = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
         //If dataItem matches the searchText, return true to include it
            let movieTitle = movie["title"] as! String
            return movieTitle.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
 
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.filteredData = self.movies
        self.tableView.reloadData()
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = filteredData![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        
        // pass the movie of the cell clicked on
        detailViewController.movie = movie
        
    }
    
//    func fadeIn(){
//        
//        let imageUrl = "https://i.imgur.com/tGbaZCY.jpg"
//        let imageRequest = NSURLRequest(url: NSURL(string: imageUrl)! as URL)
//        
//        
//        self.MovieCell.poserView.setImageWithURLRequest(
//            imageRequest,
//            placeholderImage: nil,
//            success: { (imageRequest, imageResponse, image) -> Void in
//                
//                // imageResponse will be nil if the image is cached
//                if imageResponse != nil {
//                    print("Image was NOT cached, fade in image")
//                    self.myImageView.alpha = 0.0
//                    self.myImageView.image = image
//                    UIView.animateWithDuration(0.3, animations: { () -> Void in
//                        self.myImageView.alpha = 1.0
//                    })
//                } else {
//                    print("Image was cached so just update the image")
//                    self.myImageView.image = image
//                }
//        },
//            failure: { (imageRequest, imageResponse, error) -> Void in
//                // do something for the failure condition
//        })
//    }
    
    
    

}
