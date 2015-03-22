//
//  LocationManager.swift
//  EcoBici
//
//  Created by MobileStudio04 on 21/03/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import Foundation
import MapKit

let kCurrentLocationChangedNotification = "CurrentLocationChanged"

class LocationManager: NSObject, CLLocationManagerDelegate {

    var manager: CLLocationManager
    var currentLocation: CLLocation
    override init(){
        self.manager = CLLocationManager()
        self.currentLocation = CLLocation()
        super.init()
        self.manager.delegate = self
    }
    
    class var sharedInstance : LocationManager {
        struct Static {
            static let instance : LocationManager = LocationManager()
        }
        
        return Static.instance
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        var location = locations.last as CLLocation
        self.currentLocation = location
        NSNotificationCenter.defaultCenter().postNotificationName(kCurrentLocationChangedNotification, object: nil)
    }
}