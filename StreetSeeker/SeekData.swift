//
//  SeekData.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/15.
//

import SwiftUI
import SwiftData

@Model
final class SeekData {
    var latitude: Double
    var longitude: Double
    var image: Data
    var time: String
    var distance: Double
    var steps: Int
    
    init(latitude: Double, longitude: Double, image: Data, time: String, distance: Double, steps: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
        self.time = time
        self.distance = distance
        self.steps = steps
        
    }
}
