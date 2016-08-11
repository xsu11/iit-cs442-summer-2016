//
//  FirstViewController.swift
//  tabBar
//
//  Created by Mia Liu on 7/1/16.
//  Copyright © 2016 Mia Liu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class FirstViewController: UIViewController, MKMapViewDelegate {
    
    let controllerName = "FirstViewController"
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    @IBOutlet weak var map: MKMapView!
    
    var commAreaPolygon = [(NSNumber, [[NSNumber]], Int)]() // [(area_num, [latitude, logitude], crimeCount)]
    var maxCrimeCount: Int?
    var minCrimeCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            let commAreaFR = NSFetchRequest(entityName: "CommArea")
            let commArea = try self.managedObjectContext!.executeFetchRequest(commAreaFR) as! [CommArea]
            var crimeCounts = [Int]()
            for commAreaData in commArea {
                let crimeFR = NSFetchRequest(entityName: "Crime")
                crimeFR.predicate = NSPredicate(format: "community_area == %i", Int(commAreaData.area_num!))
                let crimeInfo = try self.managedObjectContext!.executeFetchRequest(crimeFR) as! [Crime]
                let commAreaGeoFR = NSFetchRequest(entityName: "CommAreaGeo")
                commAreaGeoFR.predicate = NSPredicate(format: "area_num == %i", Int(commAreaData.area_num!))
                let commAreaGeoSD = NSSortDescriptor(key: "sequence", ascending: true)
                commAreaGeoFR.sortDescriptors = [commAreaGeoSD]
                let commAreaGeo = try self.managedObjectContext!.executeFetchRequest(commAreaGeoFR) as! [CommAreaGeo]
                var polygon = [[NSNumber]]()
                for commAreaGeoData in commAreaGeo {
                    polygon.append([commAreaGeoData.latitude!, commAreaGeoData.longitude!])
                }
                crimeCounts.append(crimeInfo.count)
                commAreaPolygon.append((commAreaData.area_num!, polygon, crimeInfo.count))
            }
            maxCrimeCount = crimeCounts.maxElement()
            minCrimeCount = crimeCounts.minElement()
        } catch {
            abort()
        }
        drawMap(commAreaPolygon)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawMap(commAreaPolygon: [(NSNumber, [[NSNumber]], Int)]) {
        let entry = CLLocation(latitude: 41.868494, longitude: -87.782959)
        centerMapOnLocation(entry)
        for polygon in commAreaPolygon {
            drawPolygon(polygon.1, title: String(polygon.2))
        }
    }
    
    func drawPolygon( polygons: [[NSNumber]], title: String ) {
        var points: [CLLocationCoordinate2D] = []
        for i in 0..<polygons.count {
            points.append(CLLocationCoordinate2D(latitude: Double(polygons[i][0]), longitude: Double(polygons[i][1])))
        }
        let figure = MKPolygon(coordinates: &points, count: polygons.count)
        figure.title = title
        self.map.addOverlay(figure)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 40000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.strokeColor = UIColor.grayColor()
            polygonRenderer.lineWidth = 1
            var trans_gray = UIColor()
            let crimeCount = Int(overlay.title!!)!
            let step = (maxCrimeCount! - minCrimeCount!) / 5
            let alpha: CGFloat = 0.5
            if (crimeCount >= minCrimeCount! + 0 * step && crimeCount < minCrimeCount! + 1 * step) {
                trans_gray = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: alpha)
            } else if (crimeCount >= minCrimeCount! + 1 * step && crimeCount < minCrimeCount! + 2 * step) {
                trans_gray = UIColor(red: 0.4, green: 0.8, blue: 0.0, alpha: alpha)
            } else if (crimeCount >= minCrimeCount! + 2 * step && crimeCount < minCrimeCount! + 3 * step) {
                trans_gray = UIColor(red: 0.6, green: 0.6, blue: 0.0, alpha: alpha)
            } else if (crimeCount >= minCrimeCount! + 3 * step && crimeCount < minCrimeCount! + 4 * step) {
                trans_gray = UIColor(red: 0.8, green: 0.4, blue: 0.0, alpha: alpha)
            } else {
                trans_gray = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: alpha)
            }

            polygonRenderer.fillColor = trans_gray
            return polygonRenderer
        }
        return MKPolylineRenderer()
    }

}

