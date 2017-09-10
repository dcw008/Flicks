
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
              
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        MovieDBClient.getMovies(endpoint: endpoint) { (movies: [NSDictionary]?) in
            self.movies = movies
            MBProgressHUD.hide(for: self.view, animated: true)
            //print(self.movies)
            self.filteredData = self.movies
            self.tableView.reloadData()
            
        }
        
        
    
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
//        cell.overviewTextView.scrollRangeToVisible(NSRange(location: 0, length:0))

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
        
        //detailViewController.gradientLayer.frame = detailViewController.backdropImage.bounds
        
    }
    

    
    
    

}
