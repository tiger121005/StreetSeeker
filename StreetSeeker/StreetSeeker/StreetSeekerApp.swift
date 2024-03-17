//
//  StreetSeekerApp.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import SwiftUI
import SwiftData

@main
struct StreetSeekerApp: App {

    var body: some Scene {
        WindowGroup {
            StartView()
            
        }
        .modelContainer(for: SeekData.self)
    }
}
