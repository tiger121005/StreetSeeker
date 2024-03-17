//
//  LocationManager.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//
import SwiftUI
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!
    }
    

}


enum CLAuthorizationStatus: Int32, @unchecked Sendable {
    //未選択
    case notDetermined = 0
    //位置情報サービスが許可されていない
    case restricted = 1
    //拒否または設定が無効
    case denied = 2
    //常に許可
    case authoraizedAlways = 3
    //使用中のみ許可
    case authorizedWhenInUse = 4
    //許可
    static var authorized: CLAuthorizationStatus = .notDetermined
}
