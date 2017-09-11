//
//  YoutubeViewController.swift
//  Flicks
//
//  Created by Derrick Wong on 9/11/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class YoutubeViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var youtubeVideoUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        if let youtubeVideoUrl = self.youtubeVideoUrl{
            webView.loadRequest(URLRequest(url: youtubeVideoUrl))
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //start activity animation
        loadingIndicator.alpha = 1
        loadingIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //end activity animation
        loadingIndicator.stopAnimating()
        loadingIndicator.alpha = 0
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
