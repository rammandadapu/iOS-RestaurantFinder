//
//  FavoriteStreetViewController.swift
//  RestaurantFinder
//
//  Created by Vijay reddy Muniswamy on 5/24/16.
//  Copyright © 2016 Ram Mandadapu. All rights reserved.
//

import UIKit
import GoogleMaps

class FavoriteStreetViewController: UIViewController , GMSMapViewDelegate{

    var lat:Double!
    var lng:Double!
    
    var locationManager = CLLocationManager();
    
    
    @IBOutlet weak var tviwew: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panoView = GMSPanoramaView(frame: CGRectZero)
        panoView.delegate = self
        self.view = panoView
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lng))
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension FavoriteStreetViewController: GMSPanoramaViewDelegate {
    func panoramaView(view: GMSPanoramaView, error: NSError, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        print("\(coordinate.latitude) \(coordinate.longitude) not available")
}
}
