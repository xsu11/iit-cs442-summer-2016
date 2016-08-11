//
//  CommAreaGeo+CoreDataProperties.swift
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

extension CommAreaGeo {

    // Attributes
    @NSManaged var area_num: NSNumber? // Int
    @NSManaged var longitude: NSNumber? // Double
    @NSManaged var latitude: NSNumber? // Double
    @NSManaged var sequence: NSNumber? // Int
    
    // Relations
    @NSManaged var comm_area_info: CommArea?

}
