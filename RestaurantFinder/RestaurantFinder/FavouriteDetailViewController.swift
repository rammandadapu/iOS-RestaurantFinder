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
            self.navigationItem.title = business.title
            
            self.ratingImage.setImageWithURL(NSURL(string: self.business.rtgurrl!)!)
            
            print(self.business.latitude!)
            print(self.business.longitude!)
            
            var staticMapURL: String = "https://maps.googleapis.com/maps/api/staticmap?center="
            
            staticMapURL += self.business.latitude!.stringValue+","+self.business.longitude!.stringValue
            
            staticMapURL += "&zoom=17&size=450x450&maptype=roadmap&markers=color:red%7Clabel:R%7C"
            
            staticMapURL += self.business.latitude!.stringValue+","+self.business.longitude!.stringValue
            
            self.staticMap.setImageWithURL(NSURL(string: staticMapURL)!)
            
            let reviewCount = self.business.reviewint
            if (reviewCount == 1) {
                self.reviewCount.text = "\(reviewCount) review"
            } else {
                self.reviewCount.text = "\(reviewCount) reviews"
            }
            
            self.addressLabel.text = self.business.addressshort
            self.descriptionLabel.text = self.business.description
            self.phoneLabel.text = "Phone: "+self.business.phone!
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
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
}