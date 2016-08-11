//
//  CrimeLoc+CoreDataProperties.swift
//  CrimeDataInChicago
//
//  Created by xinsu on 7/1/16.
//  Copyright © 2016 Illinois Institute of Technology. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CrimeLoc {

    // Attributes
    @NSManaged var id: NSNumber? // Int
    @NSManaged var latitude: NSNumber? // Double
    @NSManaged var longitude: NSNumber? // Double
    @NSManaged var x_coordinate: NSNumber? // Double
    @NSManaged var y_coordinate: NSNumber? // Double
    
    // Relations
    @NSManaged var crime_info: Crime?

}
