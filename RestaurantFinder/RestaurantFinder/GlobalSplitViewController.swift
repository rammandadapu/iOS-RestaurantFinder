//
//  GlobalSplitViewController.swift
//  RestaurantFinder
//
//  Created by Ram Mandadapu on 5/23/16.
//  Copyright © 2016 Ram Mandadapu. All rights reserved.
//
import UIKit

class GlobalSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool{
        return true
    }
    
}