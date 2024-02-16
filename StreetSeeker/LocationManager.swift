//
//  LocationManager.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var location = CLLocation()

    override init() {
        super.init()

        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = 2
        self.manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                           didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!
    }

}
