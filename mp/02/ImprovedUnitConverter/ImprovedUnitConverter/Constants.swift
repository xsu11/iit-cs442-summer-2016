//
//  Constants.swift
//  UnitConverter
//
//  Created by xinsu on 6/10/16.
//  Copyright © 2016 Illinois Institute of Technology. All rights reserved.
//

import Foundation

class Constants {
    
    var initialSettings: [String: AnyObject]?
    
    var categories: NSArray?
    var basicTypes: [String:String]?
    
    init() {
        // Load InitialSettings property list
        let path = NSBundle.mainBundle().pathForResource("InitialSettings", ofType: "plist")
        initialSettings = NSDictionary(contentsOfFile: path!) as? [String:AnyObject]
        
        categories = initialSettings!["Categories"] as? NSArray
        basicTypes = initialSettings!["Basic Types"] as? [String:String]
    }
    
}