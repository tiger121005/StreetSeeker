//
//  SliderManager.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/03/31.
//

import SwiftUI

let sliderManager = SliderManager.shared

class SliderManager {
    static var shared = SliderManager()
    
    let minLimit: Int = 500
    let maxLimit: Int = 5000
    let interval: Int = 100
    
    let num = (5000 - 500) / 100
    
    let defaultMin: Int = 700
    let defaultMax: Int = 2000
    
    let startMin: Int = 2
    let startMax: Int = 15
    
    var minLimitInt: Int = 0
    var maxLimitInt: Int = 45
    
    func value(value: Int) -> Int {
        return (value * interval) + minLimit
    }
    
}
