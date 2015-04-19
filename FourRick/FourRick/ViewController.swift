//
//  ViewController.swift
//  FourRick
//
//  Created by MobileStudio04 on 18/04/15.
//  Copyright (c) 2015 Mobintum. All rights reserved.
//

import UIKit
import MapKit
let kLatitudeStartPoint     = 19.421744
let kLongitudeStartPoint    = -99.170586

class ViewController: UIViewController, MKMapViewDelegate {
    
    let clientId = "KFBD1D243LNTYSNNUWJ1X3ZD4V5JXJ04IB0OEDV11JR1OROX"
    let clientSecret = "DMTPETRTOC3BRZEK2VIWZV3A1MPIHV4XO2IHMNH4Q4MM5YNQ"
    let baseURL = "https://api.foursquare.com/v2/venues/search?"
    
    var venuesArray = [Venue]()
    var marksArray = [VenueMark]()
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var radioSlider: MKMapView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
 
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentLocationChanged", name: kCurrentLocationChangedNotification, object: nil)
        
        //LocationManager.sharedInstance.manager.startUpdatingLocation()
        var span = MKCoordinateSpanMake(0.15, 0.1)
        //self.coordinate = CLLocationCoordinate2DMake(kLatitudeStartPoint, kLongitudeStartPoint)
        var coordinate = CLLocationCoordinate2DMake(kLatitudeStartPoint, kLongitudeStartPoint)
        var region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: false)
        //self.mapView.showsUserLocation = true

        //loadPlaces("sushi", center: coordinate)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyBoardNotification()
    }
    @IBAction func serchPressed(sender: AnyObject) {
        
        var searchText = self.textField.text
        if !searchText.isEmpty{
            println(searchText)
          
            self.venuesArray.removeAll()
            self.marksArray.removeAll()
            self.mapView.removeAnnotations(marksArray)
            var centerMap = mapView.centerCoordinate
            
            loadPlaces(searchText,center: centerMap)
        }
       
        
    }
    
    
    func registerForKeyBoardNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    func keyboardWillShow(notification: NSNotification){
        
        println("Visible")
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(){
            
            self.bottomConstraint.constant = keyboardSize.height
            UIView.animateWithDuration(0.25, animations: {  () -> Void in
              self.view.layoutIfNeeded()
            })
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        println("hide")
        bottomConstraint.constant = 0
        UIView.animateWithDuration(0.25, animations: {  () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation.classForCoder()){
            return nil
        } else if annotation.isKindOfClass(VenueMark.classForCoder()){
            
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

    
    func loadPlaces( searchText: String, center: CLLocationCoordinate2D){
        
        let manager = AFHTTPRequestOperationManager()
        var parameters = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "v": "20130815",
            "ll": "\(center.latitude),\(center.longitude)",
            "query": searchText
        ]
       
        
        manager.GET(baseURL, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            //Success
            
            //println(responseObject)
            
            if let meta = responseObject["meta"] as? NSDictionary {
                
                if meta["code"] as Int == 200 {
                    
                    if let response = responseObject["response"] as? NSDictionary {
                    
                        if let venues = response["venues"] as? NSArray {
                            
                            for venue in venues {
                                
                                var name = venue["name"] as String
                                var locationDict = venue["location"] as NSDictionary
                                var latitude = locationDict["lat"] as Double
                                var longitude = locationDict["lng"] as Double
                                
                                var venueObj = Venue(name: name, lat: latitude, lng: longitude)
                                self.venuesArray.append(venueObj)
                                self.marksArray.append(VenueMark(venue: venueObj))
                                
                                println("Place: " + name)
                                
                            }
                    
                            self.mapView.addAnnotations(self.marksArray)

                        }
                    }
                }
            }
            
                
           

            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
                println(error.localizedDescription)
                
        })

       
    }
    
  


}

