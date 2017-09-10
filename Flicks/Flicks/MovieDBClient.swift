//
//  MovieDBClient.swift
//  Flicks
//
//  Created by Derrick Wong on 9/9/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit
import AFNetworking


class MovieDBClient {
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    
    
    //completion is a function closure that takes a NSDictionary
    class func getDetails(id: Int, completion: @escaping (NSDictionary?) -> Void){
        
//        var detailsDictionary: NSDictionary?
        let url = URL(string: "\(MovieDBClient.baseUrl)\(id)?api_key=\(MovieDBClient.apiKey)")
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            // ... Use the new data to update the data source ...
            if let data = dataOrNil{
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //print(responseDictionary)
//                    self.movieDetails = responseDictionary
                    
//                    detailsDictionary = responseDictionary
                    
                    DispatchQueue.main.async {
                        //change the UI on the main thread
                        completion(responseDictionary)
                    }
                    
                }
            }
        })
        task.resume()
    }
    
    //pass most popular endpoint or highly rated url endpoint
    class func getMovies(endpoint: String?, completion: @escaping ([NSDictionary]?) -> Void){
        
        print("endpoint: \(endpoint!)")
        
        let url = URL(string: "\(MovieDBClient.baseUrl)\(endpoint!)?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //set the task
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            
            if let data = dataOrNil {
                
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //("response: \(responseDictionary)")
                    
                    //load the data then update filteredData
                    
                    
                    let results = responseDictionary["results"] as? [NSDictionary]
                    
                    //print(results)
                    
                    DispatchQueue.main.async {
                        completion(results)
                    }

                    
                }
            }
            
        })
        task.resume()
    }
    

    
}
