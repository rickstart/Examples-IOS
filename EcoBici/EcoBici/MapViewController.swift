//
//  MapViewController.swift
//  EcoBici
//
//  Created by MobileStudio04 on 07/03/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import UIKit
import MapKit
let kEcoBiciStationsURL = "http://ecobici.epicwin.mx/api/estaciones"

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var stationArray: [EBStationMark] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var span = MKCoordinateSpanMake(0.15,0.15)
        var coordinate = CLLocationCoordinate2DMake(19.427838, -99.158646)
        var region = MKCoordinateRegionMake(coordinate, span)
        var region2 = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
        self.mapView.setRegion(region, animated: true)

        loadStations()
        
        
    }
    
    func loadStations() {
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html")
        
        manager.GET(kEcoBiciStationsURL, parameters: nil, success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!)-> Void in

            println(responseObject)
            
            if let points = responseObject["points"] as? NSArray{
                for dict in points{
                    var station = EBStation(dictionary: dict as NSDictionary)
                    self.stationArray.append(EBStationMark(station: station))
                    
                    
                }
            }
            self.mapView.addAnnotations(self.stationArray)
            println(self.stationArray)
            
          
        
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!)-> Void in
                
                println(error.localizedDescription)
        
        })
    }
    
    
    
    
    // MARK: - MKMapViewDelegate
    /*
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation.classForCoder()){
            return nil
        } else if annotation.isKindOfClass(EBStationMark.classForCoder()){
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("MSMark") as MKPinAnnotationView?
            
            if pinView == nil{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MSMark")
                pinView?.pinColor = MKPinAnnotationColor.Green
                pinView?.animatesDrop = true
                pinView?.canShowCallout = true
                pinView?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIView
            } else {
                
                pinView?.annotation = annotation
                
                
            }
            return pinView
        }
        
        return nil
    }*/
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("Button detailed pressed")
    }

}


