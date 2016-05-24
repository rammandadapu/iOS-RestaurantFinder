//
//  StreetViewViewController.swift
//  YelpAssignment
//
//  Created by Vijay reddy Muniswamy on 5/23/16.
//  Copyright © 2016 seema phalke. All rights reserved.
//

import UIKit
import GoogleMaps

class StreetViewViewController: UIViewController , GMSMapViewDelegate{
    
    var lat:Double!
    var lng:Double!
    
    @IBOutlet weak var testView: UIView!
    
    
    var locationManager = CLLocationManager();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let panoView = GMSPanoramaView(frame: CGRectZero)
        panoView.delegate = self
        self.view = panoView
        
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lng))
    }
}

extension StreetViewViewController: GMSPanoramaViewDelegate {
    func panoramaView(view: GMSPanoramaView, error: NSError, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        print("\(coordinate.latitude) \(coordinate.longitude) not available")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
