//
//  LocationServices.swift
//  WeatherApp
//
//  Created by Tushar on 29/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import UIKit
import CoreLocation

class LocationServices: NSObject {

    var newestlocation: ((CLLocationCoordinate2D) -> Void)?
    var statusUpdated: ((CLAuthorizationStatus) -> Void)?
    let manager: CLLocationManager
    
    var status: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    init(mananger1: CLLocationManager = CLLocationManager()) {
        self.manager = mananger1
        super.init()
        manager.delegate = self
    }
    
    func getPermission(){
        manager.requestWhenInUseAuthorization()
    }
    
    func getLocation() {
        manager.requestLocation()
    }
}

extension LocationServices: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.sorted(by: { $0.timestamp > $1.timestamp }).first {
            self.newestlocation?(location.coordinate)
        } else {
//            self.newestlocation?(nil, nil)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Status::::", status)
        self.statusUpdated?(status)
    }
}
