//
//  EBStation.swift
//  EcoBici
//
//  Created by MobileStudio04 on 07/03/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import Foundation
import MapKit

let kStationId = "estacion_id"
let kStationName = "nombre"
let kLatitude = "x"
let kLongitude = "y"
let kNumberOfBicycles = "bicicletas"
let kNumberOfPlaces = "lugares"

class EBStation{
    
    var stationId: Int
    var stationName: String
    var latitude: String
    var longitude: String
    var numberOfBicycles: Int
    var numberOfPlaces: Int
    
    init () {
        self.stationId = 0
        self.stationName = ""
        self.latitude = ""
        self.longitude = ""
        self.numberOfBicycles = 0
        self.numberOfPlaces = 0
    }
    
    init(dictionary: NSDictionary){
        self.stationId = (dictionary[kStationId] as String).toInt()!
        self.stationName = dictionary[kStationName] as String
        self.latitude = dictionary[kLatitude] as String
        self.longitude = dictionary[kLongitude] as String
        self.numberOfBicycles = (dictionary[kNumberOfBicycles] as String).toInt()!
        self.numberOfPlaces = (dictionary[kNumberOfPlaces] as String).toInt()!
        
    }
    
    
}
class EBStationMark: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    init(station: EBStation){
        
        
        self.coordinate = CLLocationCoordinate2DMake((station.latitude as NSString).doubleValue, (station.longitude as NSString).doubleValue)
        self.title = station.stationName
        self.subtitle = "\(station.numberOfPlaces) Bicicletas \(station.numberOfBicycles) Disponibles"
        
        
    }
}