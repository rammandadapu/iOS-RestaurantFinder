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
        self.streetViewButton.hidden = false
        self.navigationItem.title = business.name
        
        self.ratingImage.hidden = false
        self.ratingImage.setImageWithURL(self.business.ratingImageURL)
        
        var staticMapURL: String = "https://maps.googleapis.com/maps/api/staticmap?center="
        
        staticMapURL += String(format:"%f", self.business.latitude!)+","+String(format:"%f", self.business.longitude!)
        
        staticMapURL += "&zoom=17&size=450x450&maptype=roadmap&markers=color:red%7Clabel:R%7C"
        
        staticMapURL += String(format:"%f", self.business.latitude!)+","+String(format:"%f", self.business.longitude!)
        
        self.staticMap.hidden = false
        self.staticMap.setImageWithURL(NSURL(string: staticMapURL)!)
        
            self.reviewCount.hidden = false
        let reviewCount = self.business.reviewCount
        if (reviewCount == 1) {
            self.reviewCount.text = "\(reviewCount) review"
        } else {
            self.reviewCount.text = "\(reviewCount) reviews"
        }
        
            self.addressLabel.hidden = false
            self.descriptionLabel.hidden = false
            self.phoneLabel.hidden = false
        self.addressLabel.text = self.business.displayAddress
        self.descriptionLabel.text = self.business.description
        self.phoneLabel.text = "Phone: "+self.business.phone!
        
        //self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: self.business.latitude!, longitude: self.business.longitude!)
        annotation.coordinate = (coordinate)
            
            var isFavorite:Bool = false
            let fetchRequest = NSFetchRequest(entityName: "List")
            
            do {
                let answers =
                try managedContext.executeFetchRequest(fetchRequest) as![List]
                
                if !answers.isEmpty {
                    for x in answers{
                        if x.title == self.business.name{
                            print("already exist")
                            isFavorite = true
                        }
                    }
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            self.favImage.hidden = false
            if isFavorite == true {
                if let image = UIImage(named: "full_heart.png") {
                    self.favImage.setImage(image, forState: .Normal)
                }
            }
        }
        else {
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
    }
    
    @IBAction func favourites(sender: AnyObject) {
        print("vijay testing");
        print(self.business.name);
        print(self.business.reviewCount);
        print(self.business.ratingImageURL);
        
        ///////////code for deletion
        
        let fetchRequest = NSFetchRequest(entityName: "List")
        
        do {
            let answers =
            try managedContext.executeFetchRequest(fetchRequest) as![List]
            
            if !answers.isEmpty {
                for x in answers{
                    if x.title == self.business.name{
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
        person.setValue(self.business.name, forKey: "title")
        // person.setValue(self.business.ratingImageURL, forKey: "ratingimage")
        person.setValue(self.business.reviewCount, forKey: "reviewint")
        // person.setValue(self.business.imageURL, forKey: "previewimage")
        person.setValue(self.business.displayCategories, forKey: "categories")
        person.setValue(self.business.displayAddress, forKey: "address")
        person.setValue(self.business.shortAddress, forKey: "addressshort")
        let imgurl = self.business.imageURL
        let contents = imgurl?.absoluteString
        print(contents!)
        person.setValue(contents!, forKey: "imgurl")
        
        person.setValue(self.business.latitude!, forKey: "latitude")
        person.setValue(self.business.longitude!, forKey: "longitude")
        person.setValue(self.business.description, forKey: "desc")
        person.setValue(self.business.phone!, forKey: "phone")
        
        print(self.business.latitude!)
        
        let rtgurl = self.business.ratingImageURL
        let rtgstring = rtgurl.absoluteString
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
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            if(business != nil) {
                let navVC = segue.destinationViewController as! UINavigationController
                let tableVC = navVC.viewControllers.first as! StreetViewViewController
            
                tableVC.lat = self.business.latitude!
                tableVC.lng = self.business.longitude!
            }
        }
    }
}