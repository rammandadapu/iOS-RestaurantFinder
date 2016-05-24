//
//  SearchViewController.swift
//  RestaurantFinder
//
//  Created by Ram Mandadapu on 5/23/16.
//  Copyright © 2016 Ram Mandadapu. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var searchBar: UISearchBar!
    
    var latitude: Double = 37.336079
    var longitude: Double = -121.880453
    
    var results: Array<Business> = []
    
    var total: Int!
    
    var client: YelpClient!
    
    let yelpConsumerKey = "nxiczIEgf7-xAE2XN0fZhQ";
    let yelpConsumerSecret = "Cv5DFVu3pags0nABkkkQoiHDNA8";
    let yelpToken = "Kbovu2vAGmvhWmIfgfRIv1pdE7jRlODy";
    let yelpTokenSecret = "AgYyLrHoXaS2bd_eCoOnos_CIGU";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "keyword.."
        self.navigationItem.titleView = self.searchBar
        
        self.performSearch("mango")
        
    }
    
    final func performSearch(term: String, offset: Int = 0, limit: Int = 20) {
        self.searchBar.text = term
        self.searchBar.resignFirstResponder()
        self.onBeforeSearch()
        self.client.searchWithTerm(term, parameters: self.getSearchParameters(), offset: offset, sort: 0, limit: 20,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let results = (response["businesses"] as! Array).map({
                    (business: NSDictionary) -> Business in
                    return Business(dictionary: business)
                })
                self.results += results
                /*if(self.sortAZ){
                self.results.sortInPlace { $0.name < $1.name }
                }*/
                
                self.total = response["total"] as! Int
                //self.onResults(self.results, total: self.total, response: self.lastResponse)
            }, failure: {
                (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                print(error)
                self.clearResults()
                let alertController = UIAlertController(title: "", message:
                    "No Results Found..!!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func getSearchParameters() -> Dictionary<String, String> {
        
        let parameters = [
            "ll": "\(self.latitude),\(self.longitude)"
        ]
        
        return parameters
    }
    
    func onBeforeSearch() -> Void {}
    
    final func clearResults() {
        self.results = []
    }
}
