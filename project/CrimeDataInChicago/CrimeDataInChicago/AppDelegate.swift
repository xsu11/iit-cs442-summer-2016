//
//  AppDelegate.swift
//  CrimeDataInChicago
//
//  Created by xinsu on 6/22/16.
//  Copyright © 2016 Illinois Institute of Technology. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var sqliteDBManager = SQLiteDBManager()
    var dirs: [NSString]?
    var dbFilePath: String?
    var plistFilePath: String?
    var plistData: [String:AnyObject]?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let tabBarViewController = self.window!.rootViewController as! TabBarViewController
        tabBarViewController.managedObjectContext = self.managedObjectContext
        
        let firstViewController = tabBarViewController.viewControllers![0] as! FirstViewController
        firstViewController.managedObjectContext = self.managedObjectContext
        
        let splitViewController = tabBarViewController.viewControllers![tabBarViewController.viewControllers!.count-1] as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let masterTableViewcontroller = masterNavigationController.topViewController as! MasterTableViewController
        masterTableViewcontroller.managedObjectContext = self.managedObjectContext
        
        /* Add code to load data */
        dirs = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true) as [NSString]
        print(dirs)
        
        let dbFilePath = getDBFilePath()
        let didLoadData = getDidLoadData()
        if didLoadData == 0 {
            loadData(dbFilePath)
            setDidLoadData(1)
        }
        return true
    }
    
    func getDidLoadData() -> Int {
        self.plistFilePath = dirs![0].stringByAppendingPathComponent("initialSettings.plist")
        plistData = NSDictionary(contentsOfFile: self.plistFilePath!) as? [String:AnyObject]
        return plistData!["didLoadData"] as! Int
    }
    
    func setDidLoadData(didLoadData: Int) -> Bool {
        let data = NSMutableDictionary(object: 1, forKey: "didLoadData")
        data.writeToFile(plistFilePath!, atomically: true)
        return true
    }
    
    func getDBFilePath() -> String {
        // Get db file path
        self.dbFilePath = dirs![0].stringByAppendingPathComponent("crime_db.sqlite3")
        return self.dbFilePath!
    }
    func loadData(dbFilePath: String) {
        // Open database
        sqliteDBManager.openSQLiteDB(dbFilePath)
        
        // Get table names
        var statement = "SELECT sm.name FROM sqlite_master sm where sm.type = 'table' ORDER BY sm.name;"
        
        let tableName = sqliteDBManager.query(statement)
        var tableData = Array<Array<Array<String>>>()
        
        for name in tableName {
            statement = "SELECT * FROM \(name[0]);"
            let result = sqliteDBManager.query(statement)
            print("tableName=\(name)\tresult.count=\(result.count)")
            tableData.append(result)
        }
        print("tableData.count=\(tableData.count)")
        
        /*
         tableName=["comm_area"]        result.count=77
         tableName=["comm_area_geo"]    result.count=52065
         tableName=["crime"]            result.count=261922
         tableName=["crime_loc"]        result.count=261922
         tableName=["fbi_code"]         result.count=26
         tableName=["iucr"]             result.count=401
         
         tableData.count=6
         */
        
        // Start to load data into Core Data
        initCD(tableData)
        checkCD()
    }
    
    func initCD(tableData: Array<Array<Array<String>>>) -> Bool {
        var i = 0
        // Create entity objects
        let commAreaEntity = NSEntityDescription.entityForName("CommArea", inManagedObjectContext: self.managedObjectContext)
        let commAreaGeoEntity = NSEntityDescription.entityForName("CommAreaGeo", inManagedObjectContext: self.managedObjectContext)
        let crimeEntity = NSEntityDescription.entityForName("Crime", inManagedObjectContext: self.managedObjectContext)
        let crimeLocEntity = NSEntityDescription.entityForName("CrimeLoc", inManagedObjectContext: self.managedObjectContext)
        let fbiCodeEntity = NSEntityDescription.entityForName("FBICode", inManagedObjectContext: self.managedObjectContext)
        let iucrEntity = NSEntityDescription.entityForName("IUCR", inManagedObjectContext: self.managedObjectContext)
        
        // Create entity data
        let commAreaData = tableData[0]
        let commAreaGeoData = tableData[1]
        let crimeData = tableData[2]
        let crimeLocData = tableData[3]
        let fbiCodeData = tableData[4]
        let iucrData = tableData[5]
        
        // Load data into CommArea - 77
        i = 0
        for line in commAreaData {
            let commArea = CommArea(entity: commAreaEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
            /*
             CREATE TABLE comm_area(
             "area_num" TEXT,
             "area" TEXT,
             "perimeter" TEXT,
             "comarea" TEXT,
             "comarea_id" TEXT,
             "community" TEXT,
             "area_num_1" TEXT,
             "shape_area" TEXT,
             "s" TEXT
             );
             */
            
            /*
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
             @NSManaged var crime_info: [Crime]? // To Many: Crime
             @NSManaged var comm_area_geo_info: [[NSNumber]]? // To Many: CommAreaGeo
             */
            if (line[0] != "") {
                commArea.area_num = NSNumber(integer: Int(line[0])!)
            }
            if (line[1] != "") {
                commArea.area = NSNumber(double: Double(line[1])!)
            }
            if (line[2] != "") {
                commArea.perimeter = NSNumber(integer: Int(line[2])!)
            }
            if (line[3] != "") {
                commArea.comarea = NSNumber(integer: Int(line[3])!)
            }
            if (line[4] != "") {
                commArea.comarea_id = NSNumber(integer: Int(line[4])!)
            }
            if (line[5] != "") {
                commArea.community = line[5]
            }
            if (line[6] != "") {
                commArea.area_num_1 = NSNumber(integer: Int(line[6])!)
            }
            if (line[7] != "") {
                commArea.shape_area = NSNumber(double: Double(line[7])!)
            }
            if (line[8] != "") {
                commArea.shape_len = NSNumber(double: Double(line[8])!)
            }
            
            
            
            // Print log
            i += 1
            if (i % 10 == 0) {
                print("Load data into CommArea: \(i) lines have been loaded.")
            }
        }
        // Print log
        if (i % 10 != 0) {
            print("Load data into CommArea: \(i) lines have been loaded.")
        }
        print("CommArea loaded.")
        
        // Load data into CommAreaGeo - 52065
        i = 0
        for line in commAreaGeoData {
            let commAreaGeo = CommAreaGeo(entity: commAreaGeoEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
            /*
             CREATE TABLE comm_area_geo(
             "area_num" TEXT,
             "latitude" TEXT,
             "longitude" TEXT,
             "sequence" TEXT
             );
             */
            
            /*
             // Attributes
             @NSManaged var area_num: NSNumber? // Int
             @NSManaged var longitude: NSNumber? // Double
             @NSManaged var latitude: NSNumber? // Double
             @NSManaged var sequence: NSNumber? // Int
             
             // Relations
             @NSManaged var comm_area_info: CommArea?
             */
            if (line[0] != "") {
                commAreaGeo.area_num = NSNumber(integer: Int(line[0])!)
            }
            if (line[1] != "") {
                commAreaGeo.latitude = NSNumber(double: Double(line[1])!)
            }
            if (line[2] != "") {
                commAreaGeo.longitude = NSNumber(double: Double(line[2])!)
            }
            if (line[3] != "") {
                commAreaGeo.sequence = NSNumber(integer: Int(line[3])!)
            }
            
            // Print log
            i += 1
            if (i % 10000 == 0) {
                print("Load data into CommAreaGeo: \(i) lines have been loaded.")
            }
        }
        // Print log
        if (i % 10000 != 0) {
            print("Load data into CommAreaGeo: \(i) lines have been loaded.")
        }
        print("CommAreaGeo loaded.")
        
        // Load data into Crime - 261922
        i = 0
        for line in crimeData {
            let crime = Crime(entity: crimeEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
            /*
             CREATE TABLE crime(
             "id" TEXT,
             "case_number" TEXT,
             "date" TEXT,
             "block" TEXT,
             "iucr" TEXT,
             "location_description" TEXT,
             "arrest" TEXT,
             "domestic" TEXT,
             "community_area" TEXT,
             "fbi_code" TEXT
             );
             */
            
            /*
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
             */
            if (line[0] != "") {
                crime.id = NSNumber(integer: Int(line[0])!)
            }
            if (line[1] != "") {
                crime.case_number = line[1]
            }
            if (line[2] != "") {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss a"
                crime.date = dateFormatter.dateFromString(line[2])
            }
            if (line[3] != "") {
                crime.block = line[3]
            }
            if (line[4] != "") {
                crime.iucr = line[4]
            }
            if (line[5] != "") {
                crime.location_description = line[5]
            }
            if (line[6] != "") {
                crime.arrest = (line[6] == "False" ? 0 : 1)
            }
            if (line[7] != "") {
                crime.domestic = (line[7] == "False" ? 0 : 1)
            }
            if (line[8] != "") {
                crime.community_area = NSNumber(integer: Int(line[8])!)
            }
            if (line[9] != "") {
                crime.fbi_code = line[9]
            }
            
            // Print log
            i += 1
            if (i % 100000 == 0) {
                print("Load data into Crime: \(i) lines have been loaded.")
            }
        }
        // Print log
        if (i % 100000 != 0) {
            print("Load data into Crime: \(i) lines have been loaded.")
        }
        print("Crime loaded.")
        
        // Load data into CrimeLoc - 261922
        i = 0
        for line in crimeLocData {
            let crimeLoc = CrimeLoc(entity: crimeLocEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
            /*
             CREATE TABLE crime_loc(
             "id" TEXT,
             "x_coordinate" TEXT,
             "y_coordinate" TEXT,
             "latitude" TEXT,
             "longitude" TEXT
             );
             */
            
            /*
             // Attributes
             @NSManaged var id: NSNumber? // Int
             @NSManaged var latitude: NSNumber? // Double
             @NSManaged var longitude: NSNumber? // Double
             @NSManaged var x_coordinate: NSNumber? // Double
             @NSManaged var y_coordinate: NSNumber? // Double
             
             // Relations
             @NSManaged var crime_info: Crime?
             */
            if (line[0] != "") {
                crimeLoc.id = NSNumber(double: Double(line[0])!)
            }
            if (line[1] != "") {
                crimeLoc.x_coordinate = NSNumber(double: Double(line[1])!)
            }
            if (line[2] != "") {
                crimeLoc.y_coordinate = NSNumber(double: Double(line[2])!)
            }
            if (line[3] != "") {
                crimeLoc.latitude = NSNumber(double: Double(line[3])!)
            }
            if (line[4] != "") {
                crimeLoc.longitude = NSNumber(double: Double(line[4])!)
            }
            
            // Print log
            i += 1
            if (i % 100000 == 0) {
                print("Load data into CrimeLoc: \(i) lines have been loaded.")
            }
        }
        // Print log
        if (i % 100000 != 0) {
            print("Load data into CrimeLoc: \(i) lines have been loaded.")
        }
        print("CrimeLoc loaded.")
        
        // Load data into FBICode - 26
        i = 0
        for line in fbiCodeData {
            let fbiCode = FBICode(entity: fbiCodeEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
            /*
             CREATE TABLE fbi_code(
             "fbi_code" TEXT,
             "offense" TEXT,
             "relate" TEXT
             );
             */
            
            /*
             // Attributes
             @NSManaged var fbi_code: String?
             @NSManaged var offense: String?
             @NSManaged var relate: String?
             
             // Relations
             @NSManaged var crime_info: Crime?
             */
            if (line[0] != "") {
                fbiCode.fbi_code = line[0]
            }
            if (line[1] != "") {
                fbiCode.offense = line[1]
            }
            if (line[2] != "") {
                fbiCode.relate = line[2]
            }
            
            // Print log
            i += 1
            if (i % 10 == 0) {
                print("Load data into FBICode: \(i) lines have been loaded.")
            }
        }
        // Print log
        if (i % 10 != 0) {
            print("Load data into FBICode: \(i) lines have been loaded.")
        }
        print("FBICode loaded.")
        
        // Load data into IUCR - 401
        i = 0
        for line in iucrData {
            let iucr = IUCR(entity: iucrEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
            /*
             CREATE TABLE iucr(
             "iucr" TEXT,
             "primary_description" TEXT,
             "secondary_description" TEXT,
             "index_code" TEXT
             );
             */
            
            /*
             // Attributes
             @NSManaged var index_code: String?
             @NSManaged var iucr: String?
             @NSManaged var primary_description: String?
             @NSManaged var secondary_description: String?
             
             // Relations
             @NSManaged var crime_info: Crime?
             */
            if (line[0] != "") {
                iucr.iucr = line[0]
            }
            if (line[1] != "") {
                iucr.primary_description = line[1]
            }
            if (line[2] != "") {
                iucr.secondary_description = line[2]
            }
            if (line[3] != "") {
                iucr.index_code = line[3]
            }
            
            // Print log
            i += 1
            if (i % 100 == 0) {
                print("Load data into IUCR: \(i) lines have been loaded.")
            }
        }
        // Print log
        if (i % 100 != 0) {
            print("Load data into IUCR: \(i) lines have been loaded.")
        }
        print("IUCR loaded.")
        
        saveContext()
        print("Context saved.")
        
        return true
    }
    
    func checkCD() -> Bool{
        do {
            var fetchRequest = NSFetchRequest(entityName: "CommArea")
            let commArea = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [CommArea]
            print("commArea.count = \(commArea.count)")
            
            fetchRequest = NSFetchRequest(entityName: "CommAreaGeo")
            let commAreaGeo = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [CommAreaGeo]
            print("commAreaGeo.count = \(commAreaGeo.count)")
            
            fetchRequest = NSFetchRequest(entityName: "Crime")
            let crime = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Crime]
            print("crime.count = \(crime.count)")
            
            fetchRequest = NSFetchRequest(entityName: "CrimeLoc")
            let crimeLoc = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [CrimeLoc]
            print("crimeLoc.count = \(crimeLoc.count)")
            
            fetchRequest = NSFetchRequest(entityName: "FBICode")
            let fbiCode = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [FBICode]
            print("fbiCode.count = \(fbiCode.count)")
            
            fetchRequest = NSFetchRequest(entityName: "IUCR")
            let iucr = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [IUCR]
            print("iucr.count = \(iucr.count)")
        } catch {
            abort()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailTableViewController else { return false }
        if topAsDetailController.index == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.iit.cs.xsu11.CrimeDataInChicago" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CrimeDataInChicago", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    override func finalize() {
        sqliteDBManager.closeSQLiteDB()
    }

}

