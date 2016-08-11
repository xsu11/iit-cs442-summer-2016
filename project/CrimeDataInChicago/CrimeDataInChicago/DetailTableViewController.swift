//
//  DetailTableViewController.swift
//  tabBar
//
//  Created by Mia Liu on 7/1/16.
//  Copyright © 2016 Mia Liu. All rights reserved.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController {
    
    let controllerName = "DetailTableViewController"
    
    var managedObjectContext: NSManagedObjectContext?
    
    var filterData = FilterData()
    var filterConditions : [(String, Bool, String)]?
    var index: Int?
    var showResult: Bool?
    var showData = [String]()
    var crimeID = [NSNumber]()
    var showcrimeBlock: String?
    var showCrimeID: NSNumber?
    
    @IBOutlet weak var detailNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showResult == true {
            self.detailNavigationItem.title = "Result"
            showFilterResult()
        } else if let idx = index {
            let filter = filterConditions![idx]
            // Set showData
            if (filter.0 == filterData.categories[0]) {
                do {
                    let commAreaFR = NSFetchRequest(entityName: "CommArea")
                    
                    var commAreaSD = NSSortDescriptor()
                    if filter.1 {
                        commAreaSD = NSSortDescriptor(key: "community", ascending: true)
                    } else {
                        commAreaSD = NSSortDescriptor(key: "community", ascending: false)
                    }
                    commAreaFR.sortDescriptors = [commAreaSD]
                    let commArea = try self.managedObjectContext!.executeFetchRequest(commAreaFR) as! [CommArea]
                    
                    for commAreaData in commArea {
                        if showData.contains(commAreaData.community!) == false {
                            showData.append(commAreaData.community!)
                        }
                    }
                    filterData.area = showData
                } catch {
                    abort()
                }
            } else if (filter.0 == filterData.categories[1]) {
                do {
                    let iucrFR = NSFetchRequest(entityName: "IUCR")
                    
                    var iucrSD = NSSortDescriptor()
                    if filter.1 {
                        iucrSD = NSSortDescriptor(key: "primary_description", ascending: true)
                    } else {
                        iucrSD = NSSortDescriptor(key: "primary_description", ascending: false)
                    }
                    iucrFR.sortDescriptors = [iucrSD]
                    
                    let iucr = try self.managedObjectContext!.executeFetchRequest(iucrFR) as! [IUCR]
                    for iucrData in iucr {
                        if showData.contains(iucrData.primary_description!) == false {
                            showData.append(iucrData.primary_description!)
                        }
                    }
                    
                    filterData.iucr = showData
                } catch {
                    abort()
                }
            }
            self.detailNavigationItem.title = filter.0
        }
    }
    
    func showFilterResult() -> Bool {
        // Store result data into showData
        let crimeFR = NSFetchRequest(entityName: "Crime")
        
        var predicates = [NSPredicate]()
        var sortDescriptors = [NSSortDescriptor]()
        
        for filter in filterConditions! {
            if (filter.0 == filterData.categories[0]) { // Community Area
                // Add predicate
                do {
                    let commAreaFR = NSFetchRequest(entityName: "CommArea")
                    commAreaFR.predicate = NSPredicate(format: "community == %@", filter.2)
                    let commArea = try self.managedObjectContext!.executeFetchRequest(commAreaFR) as! [CommArea]
                    for commAreaData in commArea {
                        predicates.append(NSPredicate(format: "community_area == %@", commAreaData.area_num!))
                    }
                } catch {
                    abort()
                }
            } else if (filter.0 == filterData.categories[1]) { // Crime Type
                // Add predicate
                do {
                    let iucrFR = NSFetchRequest(entityName: "IUCR")
                    iucrFR.predicate = NSPredicate(format: " primary_description == %@", filter.2)
                    let iucr = try self.managedObjectContext!.executeFetchRequest(iucrFR) as! [IUCR]
                    var iucrPreds = [NSPredicate]()
                    for iucrData in iucr {
                        iucrPreds.append(NSPredicate(format: "iucr == %@", iucrData.iucr!))
                    }
                    predicates.append(NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: iucrPreds))
                } catch {
                    abort()
                }
            }
        }

        do {
            // Add predicate
            let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
            crimeFR.predicate = predicate
            
            // Add sortDescriptor
            sortDescriptors.append(NSSortDescriptor(key: "id", ascending: true))
            crimeFR.sortDescriptors = sortDescriptors
            
            let crime = try self.managedObjectContext!.executeFetchRequest(crimeFR) as! [Crime]
            
            for c in crime {
                showData.append(String(format: "\(c.block!)"))
                crimeID.append(c.id!)
            }
        } catch {
            abort()
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return showData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel!.text = self.showData[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.index! == (self.filterConditions?.count)! {
            performSegueWithIdentifier("showDetailMap", sender: nil)
        } else {
            performSegueWithIdentifier("showMoreDetail", sender: nil)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if self.index < (self.filterConditions?.count)! {
            self.filterConditions![self.index!].2 = self.showData[indexPath.row]
        } else if self.index == (self.filterConditions?.count)! {
            self.showCrimeID = self.crimeID[indexPath.row]
            self.showcrimeBlock = self.showData[indexPath.row]
        }
        return indexPath
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMoreDetail" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailTableViewController
            controller.filterConditions = self.filterConditions
            controller.index = self.index! + 1
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            if self.index == (filterConditions?.count)! - 1 {
                controller.showResult = true
            } else {
                controller.showResult = false
            }
        } else if segue.identifier == "showDetailMap" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailMapViewController
            controller.crimeID = self.showCrimeID!
            controller.crimeBlock = self.showcrimeBlock!
            controller.managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        }
    }
    
}
