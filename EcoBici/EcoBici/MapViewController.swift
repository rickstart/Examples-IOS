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
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var bicyclesLabel: UILabel!
    
    var stationArray: [EBStationMark] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showNearestStation", name: kCurrentLocationChangedNotification, object: nil)
        
        LocationManager.sharedInstance.manager.startUpdatingLocation()
        var span = MKCoordinateSpanMake(0.15,0.15)
        var coordinate = CLLocationCoordinate2DMake(19.427838, -99.158646)
        var region = MKCoordinateRegionMake(coordinate, span)
        var region2 = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        loadStations()
        
        
    }
    
    @IBAction func LocationButtonPressed(sender: AnyObject) {
        
        if locationEnabled(){
            
            var userLocation = self.mapView.userLocation
            var region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000)
            self.mapView.setRegion(region, animated: true)
            //self.showNearestStation()
        }
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
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation.classForCoder()){
            return nil
        } else if annotation.isKindOfClass(EBStationMark.classForCoder()){
            
            var mark = annotation as EBStationMark
            var annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("EBStationMark")
      
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "EBStationMark")
  
            } else {
                
                annotationView.annotation = annotation
                
                
            }
            
            var station = mark.ebStation
            var total = station.numberOfBicycles + station.numberOfPlaces
            var percent: CGFloat = CGFloat(station.numberOfBicycles) / CGFloat(total)
            
            annotationView.image = self.colorToImage(UIImage(named: "mark.png")!, percent: percent)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIView
            
            return annotationView
        }
        
        return nil
        
    }
   
    
    func locationEnabled() -> Bool{
    
        if CLLocationManager.locationServicesEnabled(){
    
            return true
        } else {
    
            let alertController = UIAlertController(title: "Permission", message: "Please Allow Permission to Location", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
       

    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("Button detailed pressed")
    }

    func showNearestStation(){
        
        if locationEnabled() && self.stationArray.count > 0 {
            var userLocation = self.mapView.userLocation.location
            var station = self.stationArray[0]
            
            if userLocation != nil{
                
                var distance = userLocation.distanceFromLocation(station.location)
                for currentStation in self.stationArray{
                    var currentDistance = userLocation.distanceFromLocation(currentStation.location)
                    if currentDistance < distance {
                        distance = currentDistance
                        station = currentStation
                    }
                }
                
                self.stationNameLabel.text = station.title
                self.bicyclesLabel.text = station.subtitle
            }
           
        }
        
    }
    
    func colorToImage(image:UIImage, percent: CGFloat) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        image.drawAtPoint(CGPointZero)
        var ctx = UIGraphicsGetCurrentContext()
        UIColor(hue: 0.3 * percent, saturation: 1.0, brightness: 1.0, alpha: 1.0).setFill()
        var circleRect = CGRectMake((image.size.width / 2)-6 , (image.size.height / 2)-9, image.size.width/2,image.size.height/2)
        CGContextFillEllipseInRect(ctx, circleRect)
        
        var colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorImage
    }
    
}


