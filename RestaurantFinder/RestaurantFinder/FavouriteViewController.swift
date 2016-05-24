//
//  FavouriteViewController.swift
//  YelpAssignment
//
//  Created by Vijay reddy Muniswamy on 5/23/16.
//  Copyright © 2016 seema phalke. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    /////
    
    //var viewControls : ViewControllerUtils = ViewControllerUtils()
    let managedContext = DataController().managedObjectContext
    
    var results : [List] = []
    func rslts() -> [List] {
        
        let fetchRequest = NSFetchRequest(entityName: "List")
        
        do {
            results =
                try managedContext.executeFetchRequest(fetchRequest) as![List]
            return results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return results
        }
        
    }
    
    /////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 116
        //     self.tableView.addInfiniteScrollingWithActionHandler({
        //            self.performSearch(self.searchBar.text!, offset: self.offset, limit: self.limit)
        //        })
        self.tableView.showsInfiniteScrolling = false
        // self.tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let answers = rslts()
        print("main")
        print("-----------------------------------------------------------------------")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FavouriteTableViewCell") as! FavouriteTableViewCell
        
        let business = answers[indexPath.row]
        
        let fileUrl = NSURL(string: business.imgurl!)
        if (fileUrl != nil) {
            cell.imgvw.setImageWithURL(fileUrl!)
        }
        
        cell.imgvw.layer.cornerRadius = 9.0
        cell.imgvw.layer.masksToBounds = true
        
        /*cell.title.text = "\(indexPath.row + 1). \(business.title!)"
        
        let rtgurl = NSURL(string: business.rtgurrl!)
        cell.ratingimage.setImageWithURL(rtgurl!)
        
        
        
        cell.address.text = business.address
        cell.keywords.text = business.categories*/
        
        let reviewCount = business.reviewint!
        if (reviewCount == 1) {
            cell.review.text = "\(reviewCount) review"
        } else {
            cell.review.text = "\(reviewCount) reviews"
        }
        
        cell.layoutIfNeeded()
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = rslts();
        return cnt.count;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let result = self.results[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! FavouriteDetailViewController
                controller.business = result
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

