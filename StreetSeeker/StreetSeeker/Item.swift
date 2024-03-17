//
//  Item.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
