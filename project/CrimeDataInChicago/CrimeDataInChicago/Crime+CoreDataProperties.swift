//
//  Crime+CoreDataProperties.swift
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

extension Crime {

    // Attributes
    @NSManaged var arrest: NSNumber? // Boolean
    @NSManaged var block: String?
    @NSManaged var case_number: String?
    @NSManaged var community_area: NSNumber? // Int
    @NSManaged var date: NSDate?
    @NSManaged var domestic: NSNumber? // Boolean
    @NSManaged var fbi_code: String?
    @NSManaged var id: NSNumber? // Int
    @NSManaged var iucr: String?
    @NSManaged var location_description: String?
    
    // Relations
    @NSManaged var comm_area_info: CommArea?
    @NSManaged var crime_loc_info: CrimeLoc?
    @NSManaged var iucr_info: IUCR?
    @NSManaged var fbi_code_info: FBICode?

}
