//
//  MovieDBClient.swift
//  Flicks
//
//  Created by Derrick Wong on 9/9/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit
import AFNetworking

//Makes API Calls
class MovieDBClient {
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let recommendationString = "/recommendations"
    static let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
    static let youtubeBaseUrl = "https://www.youtube.com/embed/"
    
    
    //completion is a function closure that takes a NSDictionary
    class func getDetails(id: Int, completion: @escaping (NSDictionary?) -> Void){
        
//        var detailsDictionary: NSDictionary?
        let url = URL(string: "\(baseUrl)\(id)?api_key=\(apiKey)")
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            // ... Use the new data to update the data source ...
            if let data = dataOrNil{
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    
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
        
        
        let url = URL(string: "\(baseUrl)\(endpoint!)?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //set the task
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            
            if let data = dataOrNil {
                
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {

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
    
    //get the recommended movie when given a movie id
    class func getRecommendations(id: Int, completion: @escaping ([NSDictionary]?) -> Void){
        let url = URL(string: "\(baseUrl)\(id)\(recommendationString)?api_key=\(apiKey)")
        //print(url)
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //set the task
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if error == nil{
                if let data = dataOrNil {

                    
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        
                        //print(results)
                        //print(responseDictionary)
                        let results = responseDictionary["results"] as? [NSDictionary]
                        //print("results:  \(results)")
                        DispatchQueue.main.async {
                            completion(results)
                        }
                    }
                }
            } else{
                print("ERROR")
                print(error?.localizedDescription)
            }
            
            
            
        })
        task.resume()
    }
    
    
    class func getTrailer(id: Int, completion: @escaping (String) -> Void){
        
        let url = URL(string: "\(baseUrl)\(id)/videos?api_key=\(apiKey)")
        //print(url)
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //set the task
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if error == nil{
                if let data = dataOrNil {
                    
                    
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        
                        //print(results)
                        //(responseDictionary)
                        let results = responseDictionary["results"] as? [NSDictionary]
                        //print("results:  \(results)")
                        
                        //print(results)
                        
                        let firstResult = results?[0] as? NSDictionary
                        
                        print(firstResult)
                        let key = firstResult?["key"] as! String
                        
                        print(key)
                        
                        
                        DispatchQueue.main.async {
                            completion(key)
                        }
                    }
                }
            } else{
                print("ERROR")
                print(error?.localizedDescription)
            }
            
            
            
        })
        task.resume()
        
    }

    
}
