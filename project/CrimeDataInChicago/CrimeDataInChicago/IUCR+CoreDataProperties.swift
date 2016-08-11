//
//  IUCR+CoreDataProperties.swift
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

extension IUCR {

    // Attributes
    @NSManaged var index_code: String?
    @NSManaged var iucr: String?
    @NSManaged var primary_description: String?
    @NSManaged var secondary_description: String?
    
    // Relations
    @NSManaged var crime_info: NSSet? // To Many: Crime

}
