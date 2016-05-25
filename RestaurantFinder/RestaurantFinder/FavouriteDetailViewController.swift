//
//  RestaurantViewController.swift
//  RestaurantFinder
//
//  Created by Ram Mandadapu on 5/23/16.
//  Copyright © 2016 Ram Mandadapu. All rights reserved.
//
import Foundation
import MapKit
import CoreData


class FavouriteDetailViewController: UIViewController {
    
    var business: List!
    let managedContext = DataController().managedObjectContext
    
    @IBOutlet weak var streetViewButton: UIButton!
    @IBOutlet weak var emptyMessage: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var favImage: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var staticMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(business != nil) {
            self.emptyMessage.hidden = true
            
            self.ratingImage.hidden = false
            self.favImage.hidden = false
            self.addressLabel.hidden = false
            self.descriptionLabel.hidden = false
            self.phoneLabel.hidden = false
            self.staticMap.hidden = false
            self.reviewCount.hidden = false
            self.streetViewButton.hidden = false
            self.navigationItem.title = business.title
            
            self.ratingImage.setImageWithURL(NSURL(string: self.business.rtgurrl!)!)
            
            print(self.business.latitude!)
            print(self.business.longitude!)
            
            var staticMapURL: String = "https://maps.googleapis.com/maps/api/staticmap?center="
            
            staticMapURL += self.business.latitude!.stringValue+","+self.business.longitude!.stringValue
            
            staticMapURL += "&zoom=17&size=450x450&maptype=roadmap&markers=color:red%7Clabel:R%7C"
            
            staticMapURL += self.business.latitude!.stringValue+","+self.business.longitude!.stringValue
            
            self.staticMap.setImageWithURL(NSURL(string: staticMapURL)!)
            
            let reviewCount = self.business.reviewint!
            if (reviewCount == 1) {
                self.reviewCount.text = "\(reviewCount) review"
            } else {
                self.reviewCount.text = "\(reviewCount) reviews"
            }
            
            self.addressLabel.text = self.business.addressshort
            self.descriptionLabel.text = self.business.desc
            self.phoneLabel.text = "Phone: "+self.business.phone!
            if let image = UIImage(named: "full_heart.png") {
                self.favImage.setImage(image, forState: .Normal)
            }
        } else {
            self.emptyMessage.hidden = false
            
            self.ratingImage.hidden = true
            self.favImage.hidden = true
            self.addressLabel.hidden = true
            self.descriptionLabel.hidden = true
            self.phoneLabel.hidden = true
            self.staticMap.hidden = true
            self.reviewCount.hidden = true
            self.streetViewButton.hidden = true

        }
        
        //2
        //let fetchRequest = NSFetchRequest(entityName: "RestaurantList")
        
        //3
        /*do {
        let results =
        try managedContext.executeFetchRequest(fetchRequest) as![RestaurantList]
        print("-------------")
        for var i = 0; i < results.count ; i++ {
        print(results[i].name!)
        print(results[i].reviewcount!)
        print(results[i].disaddress!)
        }
        print("-------------")
        } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
        }*/
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            if(business != nil) {
            let navVC = segue.destinationViewController as! UINavigationController
            let tableVC = navVC.viewControllers.first as! FavoriteStreetViewController
                tableVC.lat = self.business.latitude! as Double
                tableVC.lng = self.business.longitude! as Double
            }
        }
    }
    
    @IBAction func favourites(sender: AnyObject) {
        
        
        ///////////code for deletion
        
        let fetchRequest = NSFetchRequest(entityName: "List")
        
        do {
            let answers =
            try managedContext.executeFetchRequest(fetchRequest) as![List]
            
            if !answers.isEmpty {
                for x in answers{
                    if x.title == self.business.title{
                        print("already exist")
                        managedContext.deleteObject(x)
                        do {
                            try managedContext.save()
                            let alert = UIAlertView()
                            alert.title = "Alert"
                            alert.message = "Deleted from Favorites"
                            alert.addButtonWithTitle("OK")
                            alert.show()
                            if let image = UIImage(named: "empty_heart.png") {
                                self.favImage.setImage(image, forState: .Normal)
                            }
                            return
                        } catch {
                            let saveError = error as NSError
                            print(saveError)
                        }
                        
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        //2
        let entity =  NSEntityDescription.entityForName("List",
            inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        person.setValue(self.business.title, forKey: "title")
        // person.setValue(self.business.ratingImageURL, forKey: "ratingimage")
        person.setValue(self.business.reviewint, forKey: "reviewint")
        // person.setValue(self.business.imageURL, forKey: "previewimage")
        person.setValue(self.business.categories, forKey: "categories")
        person.setValue(self.business.address, forKey: "address")
        person.setValue(self.business.addressshort, forKey: "addressshort")
        let imgurl = self.business.imgurl
        let contents = imgurl
        print(contents!)
        person.setValue(contents!, forKey: "imgurl")
        
        person.setValue(self.business.latitude!, forKey: "latitude")
        person.setValue(self.business.longitude!, forKey: "longitude")
        person.setValue(self.business.phone!, forKey: "phone")
        person.setValue(self.business.desc, forKey: "desc")

        
        let rtgurl = self.business.rtgurrl
        let rtgstring = rtgurl
        print(rtgstring)
        person.setValue(rtgstring, forKey: "rtgurrl")
        //4
        do {
            try managedContext.save()
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Saved TO Favorites"
            alert.addButtonWithTitle("OK")
            alert.show()
            if let image = UIImage(named: "full_heart.png") {
                self.favImage.setImage(image, forState: .Normal)
            }
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
}