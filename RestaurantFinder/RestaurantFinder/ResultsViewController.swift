//
//  ResultsViewController.swift
//  RestaurantFinder
//
//  Created by Ram Mandadapu on 5/23/16.
//  Copyright © 2016 Ram Mandadapu. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var resultsTableView: UITableView!
    
    var searchBar: UISearchBar!
    
    var latitude: Double = 37.336079
    var longitude: Double = -121.880453
    
    
    @IBOutlet weak var sortButton: UIButton!
    var results: Array<Business> = []
    
    var total: Int!
    
    var sortRelevance:Bool = true
    
    var detailViewController: RestaurantViewController? = nil
    
    var client: YelpClient!
    
    let yelpConsumerKey = "nxiczIEgf7-xAE2XN0fZhQ";
    let yelpConsumerSecret = "Cv5DFVu3pags0nABkkkQoiHDNA8";
    let yelpToken = "Kbovu2vAGmvhWmIfgfRIv1pdE7jRlODy";
    let yelpTokenSecret = "AgYyLrHoXaS2bd_eCoOnos_CIGU";
    
    //var viewControls : ViewControllerUtils = ViewControllerUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        self.resultsTableView.delegate = self
        self.resultsTableView.dataSource = self
        self.resultsTableView.rowHeight = UITableViewAutomaticDimension
        self.resultsTableView.estimatedRowHeight = 116
        
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "keyword.."
        self.navigationItem.titleView = self.searchBar
        
        self.performSearch("mango")
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? RestaurantViewController
        }

    }
    
    @IBAction func buttonClicked(sender: AnyObject) { //Touch Up Inside action
        //sortButton.backgroundColor = UIColor.whiteColor()
        self.sortRelevance = !self.sortRelevance
        if(self.sortRelevance){
            self.sortButton.setTitle("Relevance", forState: UIControlState.Normal)
        }else{
            self.sortButton.setTitle("Distance", forState: UIControlState.Normal)
        }
        self.clearResults()
        self.performSearch(searchBar.text!)
        
    }

    
    final func performSearch(term: String, offset: Int = 0, limit: Int = 20) {
        self.searchBar.text = term
        self.searchBar.resignFirstResponder()
        self.onBeforeSearch()
        var sort: Int!
        if(self.sortRelevance){
            sort = 0
        } else{
            sort = 1
        }
        self.client.searchWithTerm(term, parameters: self.getSearchParameters(), offset: offset, sort: sort, limit: 20,
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
                self.onResults(self.results, total: self.total)
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
    
    final func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.clearResults()
        self.performSearch(searchBar.text!)
    }
    
    final func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.clearResults()
        }
    }
    
    func onResults(results: Array<Business>, total: Int) {
        //self.tableView.infiniteScrollingView.stopAnimating()
        self.resultsTableView.showsInfiniteScrolling = results.count < total
        self.resultsTableView.tableFooterView = UIView(frame: CGRectZero)
        self.resultsTableView.reloadData()
        //viewControls.hideActivityIndicator(self.view)
    }
    
    func onResultsCleared() {
        //viewControls.hideActivityIndicator(self.view)
        self.resultsTableView.showsInfiniteScrolling = false
        self.resultsTableView.reloadData()
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessTableViewCell") as? BusinessTableCell
        
        let business = self.results[indexPath.row]
        
        if (business.imageURL != nil) {
            cell?.previewImage.setImageWithURL(business.imageURL!)
        }
        
        cell?.previewImage.layer.cornerRadius = 9.0
        cell?.previewImage.layer.masksToBounds = true
        
        cell?.nameLabel.text = "\(indexPath.row + 1). \(business.name)"
        cell?.ratingImage.setImageWithURL(business.ratingImageURL)
        
        let reviewCount = business.reviewCount
        if (reviewCount == 1) {
            cell?.reviewLabel.text = "\(reviewCount) review"
        } else {
            cell?.reviewLabel.text = "\(reviewCount) reviews"
        }
        
        cell?.addressLabel.text = business.shortAddress
        cell?.categoriesLabel.text = business.displayCategories
        
        cell?.layoutIfNeeded()
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.resultsTableView.indexPathForSelectedRow {
                let result = self.results[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! RestaurantViewController
                controller.business = result
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}