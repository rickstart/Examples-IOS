import Foundation
import MapKit

let kCurrentLocationChangedNotification     = "CurrentLocationChanged"

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var manager: CLLocationManager
    var currentLocation: CLLocation
    var previousLocation: CLLocation?
    
    override init() {
        self.currentLocation = CLLocation()
        self.previousLocation = nil
        self.manager = CLLocationManager()
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var location = locations.last as CLLocation
        
        //VERIFICAMOS SI EXISTE UNA LOCALIZACIÓN PREVIA A LA QUE ESTAMOS OBTENIENDO, SI NO, ASIGNAMOS LA MISMA A LAS DOS
        if previousLocation == nil {
            
            previousLocation = location
            currentLocation = location
            NSNotificationCenter.defaultCenter().postNotificationName(kCurrentLocationChangedNotification, object: nil)
            
        } else {
            
            //SI YA TENEMOS LOCALIZACIÓN PREVIA, CALCULAMOS LA DISTANCIA ENTRE AMBAS LOCALIZACIONES
            currentLocation = location
            var distance = previousLocation?.distanceFromLocation(currentLocation)
            
            //SI LA DISTANCIA ES MAYOR A 20 METROS, LANZAMOS LA NOTIFICACIÓN PARA MOSTRAR LA NUEVA ESTACIÓN MAS CERCANA
            if distance > 20 {
                
                NSNotificationCenter.defaultCenter().postNotificationName(kCurrentLocationChangedNotification, object: nil)
                
            }
        }
        
    }
    
}



