//
//  ViewController.swift
//  MapKitTest
//
//  Created by MobileStudio04 on 07/03/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var span = MKCoordinateSpanMake(0.15,0.15)
        var coordinate = CLLocationCoordinate2DMake(19.427838, -99.158646)
        var region = MKCoordinateRegionMake(coordinate, span)
        var region2 = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
        self.mapView.setRegion(region2, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func pinButtonPressed(sender: AnyObject) {
        var msPin = MyCustonMark()
        self.mapView.addAnnotation(msPin)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation.classForCoder()){
            return nil
        } else if annotation.isKindOfClass(MyCustonMark.classForCoder()){
            
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
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("Button detailed pressed")
    }
    

}

class MyCustonMark: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    override init(){
        self.coordinate = CLLocationCoordinate2DMake(19.427838, -99.158646)
        self.title = "Mobile Studio"
        self.subtitle = "Dinamarca 44"
    }
}

