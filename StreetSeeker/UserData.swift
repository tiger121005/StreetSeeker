//
//  UserData.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import SwiftData
import SwiftUI
import MapKit

class UserData {
    var userName: String
    
    init() {
        self.userName = UserDefaultsKey.userName.get() ?? "no name"
    }
}



