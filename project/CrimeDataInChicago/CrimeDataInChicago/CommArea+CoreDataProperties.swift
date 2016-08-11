//
//  CommArea+CoreDataProperties.swift
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

extension CommArea {

    // Attributes
    @NSManaged var area: NSNumber? // Double
    @NSManaged var area_num_1: NSNumber? // Int
    @NSManaged var area_num: NSNumber? // Int
    @NSManaged var comarea: NSNumber? // Int
    @NSManaged var comarea_id: NSNumber? // Int
    @NSManaged var community: String?
    @NSManaged var perimeter: NSNumber? // Int
    @NSManaged var shape_area: NSNumber? // Double
    @NSManaged var shape_len: NSNumber? // Double
    
    // Relations
    @NSManaged var crime_info: NSSet? // To Many: Crime
    @NSManaged var comm_area_geo_info: NSSet? // To Many: CommAreaGeo

}
