//
//  FBICode+CoreDataProperties.swift
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

extension FBICode {

    // Attributes
    @NSManaged var fbi_code: String?
    @NSManaged var offense: String?
    @NSManaged var relate: String?
    
    // Relations
    @NSManaged var crime_info: Crime?

}
