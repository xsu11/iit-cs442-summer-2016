//
//  TabBarViewController.swift
//  tabBar
//
//  Created by Mia Liu on 7/1/16.
//  Copyright © 2016 Mia Liu. All rights reserved.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController {
    
    let controllerName = "TabBarViewController"

    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
