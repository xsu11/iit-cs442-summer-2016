//
//  DetailMapViewController.swift
//  tabBar
//
//  Created by Mia Liu on 7/2/16.
//  Copyright © 2016 Mia Liu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class DetailMapViewController: UIViewController, MKMapViewDelegate {

    let controllerName = "DetailMapViewController"
    
    var managedObjectContext: NSManagedObjectContext?
    
    var crimeID: NSNumber?
    var crimeLocation: CLLocation?
    var crimeBlock: String?
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var detailMapNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.detailMapNavigationItem.title = crimeBlock!
        do {
            let crimeLocFR = NSFetchRequest(entityName: "CrimeLoc")
            crimeLocFR.predicate = NSPredicate(format: "id == %i", Int(crimeID!))
            let crimeLoc = try self.managedObjectContext!.executeFetchRequest(crimeLocFR) as! [CrimeLoc]
            if crimeLoc.count > 0 {
                if crimeLoc[0].latitude != nil && crimeLoc[0].longitude != nil {
                    crimeLocation = CLLocation(latitude: Double(crimeLoc[0].latitude!), longitude: Double(crimeLoc[0].longitude!))
                    var mapAnnotation: MKPointAnnotation?
                    if let loc = self.crimeLocation {
                        centerMapOnLocation(loc)
                        if let annotation = mapAnnotation {
                            annotation.coordinate = loc.coordinate
                            annotation.title = crimeBlock!
                        } else {
                            mapAnnotation = MKPointAnnotation()
                            mapAnnotation!.coordinate = loc.coordinate
                            mapAnnotation!.title = crimeBlock!
                            map.addAnnotation(mapAnnotation!)
                        }
                    }
                }
            }
        } catch {
            abort()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
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
