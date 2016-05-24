//
//  List+CoreDataProperties.swift
//  
//
//  Created by Divya Chittimalla on 5/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension List {

    @NSManaged var address: String?
    @NSManaged var addressshort: String?
    @NSManaged var categories: String?
    @NSManaged var imgurl: String?
    @NSManaged var reviewint: NSNumber?
    @NSManaged var rtgurrl: String?
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var phone: String?

}
