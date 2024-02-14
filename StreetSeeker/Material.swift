//
//  Material.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import SwiftUI
import MapKit

let material = Material.shared

class Material {
    
    static var shared = Material()
    
    let meterPerLatitudeDegrees = 0.000009
    let polygonSideLength = 50.0
    let altitudeBeforeAnimation = 1000.0
}


extension Color {
    
    
}

extension CLLocationCoordinate2D {
    static let defaultLocation = CLLocationCoordinate2D(latitude: 135, longitude: 35)
}
