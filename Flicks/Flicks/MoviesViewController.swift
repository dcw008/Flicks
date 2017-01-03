//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Derrick Wong on 1/2/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //outlet to the table view
    @IBOutlet weak var tableView: UITableView!
    
    //array of dictionaries that represent each movie
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Network api request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //print("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                    
                }
            }
        })
        task.resume()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        // index path tells the cell where it is in the tableView
        
        let cell = tableView.dequeueReusableCell( withIdentifier: "MovieCell", for: indexPath)
        
        let movie = movies![indexPath.row]
        
        let title = movie["title"] as! String
        
        cell.textLabel!.text = title
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
