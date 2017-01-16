//
//  Movie.swift
//  Flicks
//
//  Created by Derrick Wong on 1/15/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    private var title: String = ""
    private var overview: String = ""
    private var posterImage: UIImageView
    
    func setTitle(title: String){
        self.title = title
        
    }
    
    func getTitle() -> String{
        if(self.title != nil){
            return self.title
        } else {
            return ""
        }
    }
    
    func setOverview(overview: String){
        self.overview = overview
    }
    
    func getOverview() -> String{
        if(self.overview != nil){
            return self.overview
        } else {
            return ""
        }
    }
    


}
