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
    var time: Int
    var distance: Int
    var steps: Int
    var date: Date
    
    init(latitude: Double, longitude: Double, time: Int, distance: Int, steps: Int, date: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
        self.distance = distance
        self.steps = steps
        self.date = date
        
    }
}
