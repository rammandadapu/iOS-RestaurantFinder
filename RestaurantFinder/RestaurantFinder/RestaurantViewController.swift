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


class RestaurantViewController: UIViewController, MKMapViewDelegate {
    
    var business: Business!
    //let managedContext = DataController().managedObjectContext
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var staticMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(business != nil) {
        self.navigationItem.title = business.name
        
        self.ratingImage.setImageWithURL(self.business.ratingImageURL)
        
        var staticMapURL: String = "https://maps.googleapis.com/maps/api/staticmap?center="
        
        staticMapURL += String(format:"%f", self.business.latitude!)+","+String(format:"%f", self.business.longitude!)
        
        staticMapURL += "&zoom=17&size=450x450&maptype=roadmap&markers=color:red%7Clabel:R%7C"
        
        staticMapURL += String(format:"%f", self.business.latitude!)+","+String(format:"%f", self.business.longitude!)
        
        self.staticMap.setImageWithURL(NSURL(string: staticMapURL)!)
        
        let reviewCount = self.business.reviewCount
        if (reviewCount == 1) {
            self.reviewCount.text = "\(reviewCount) review"
        } else {
            self.reviewCount.text = "\(reviewCount) reviews"
        }
        
        self.addressLabel.text = self.business.displayAddress
        self.descriptionLabel.text = self.business.description
        self.phoneLabel.text = "Phone: "+self.business.phone!
        
        //self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: self.business.latitude!, longitude: self.business.longitude!)
        annotation.coordinate = (coordinate)
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
        print("vijay testing");
        print(self.business.name);
        print(self.business.reviewCount);
        print(self.business.ratingImageURL);
        
        
        //2
        /*let entity =  NSEntityDescription.entityForName("RestaurantList",
            inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        person.setValue(self.business.name, forKey: "name")
        // person.setValue(self.business.ratingImageURL, forKey: "ratingimage")
        person.setValue(self.business.reviewCount, forKey: "reviewcount")
        // person.setValue(self.business.imageURL, forKey: "previewimage")
        person.setValue(self.business.displayCategories, forKey: "categories")
        person.setValue(self.business.displayAddress, forKey: "disaddress")
        person.setValue(self.business.shortAddress, forKey: "shtaddress")
        
        //4
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }*/
        
    }
}