//
//  VenueMark.swift
//  FourRick
//
//  Created by MobileStudio04 on 18/04/15.
//  Copyright (c) 2015 Mobintum. All rights reserved.
//

import MapKit


class VenueMark: NSObject, MKAnnotation {
    var title = ""
    var coordinate = CLLocationCoordinate2DMake(0, 0)
    var venue: Venue!
    
    init(venue: Venue){
        self.venue = venue
        self.title = venue.name
        self.coordinate = CLLocationCoordinate2DMake(venue.lat, venue.lng)
        
    }
    
}
