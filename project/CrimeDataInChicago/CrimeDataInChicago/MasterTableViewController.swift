//
//  MasterViewController.swift
//  Filters
//
//  Created by Mia Liu on 6/27/16.
//  Copyright © 2016 Mia Liu. All rights reserved.
//

import UIKit
import CoreData

class MasterTableViewController: UITableViewController {
    
    let controllerName = "MasterTableViewController"
    
    var detailViewController: DetailTableViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    @IBOutlet weak var masterNavigationItem: UINavigationItem!

    let filterData = FilterData()
    var btnUps = [Bool]()
    var switchStates = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.masterNavigationItem.title = "Choose Filter"
        
        self.btnUps = [Bool](count: filterData.categories.count, repeatedValue: true)
        self.switchStates = [Bool](count: filterData.categories.count, repeatedValue: true)
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailTableViewController
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var filterConditions = [(String, Bool, String)]()
            for i in 0 ..< filterData.categories.count {
                if (switchStates[i]) {
                    filterConditions.append((filterData.categories[i], btnUps[i], ""))
                }
            }
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailTableViewController
            controller.filterConditions = filterConditions
            controller.index = 0
            controller.showResult = false
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        }
    }
    
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData.categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FilterTableViewCell
        cell.label.text = filterData.categories[indexPath.row]
        cell.setStates(buttonUp: btnUps[indexPath.row], switchState: switchStates[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Cell
    @IBAction func btnTouchInside(sender: UIButton) {
        let cell = sender.superview!.superview as? FilterTableViewCell;
        cell?.turnBtn()
        let indexPath = self.tableView.indexPathForCell(cell!)
        let chooseRow = (indexPath?.row)!
        btnUps[chooseRow] = !btnUps[chooseRow]
    }
    
    @IBAction func switchValueChange(sender: UISwitch) {
        let cell = sender.superview!.superview as? FilterTableViewCell;
        cell?.turnSwitcher()
        let indexPath = self.tableView.indexPathForCell(cell!)
        let chooseRow = (indexPath?.row)!
        switchStates[chooseRow] = !switchStates[chooseRow]
    }
    
}

