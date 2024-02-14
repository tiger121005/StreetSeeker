//
//  ProfileView.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/15.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    
    let userData = UserData()
    var userName: String = ""
    
    init() {
        userName = userData.userName
        
    }
    
    
    var body: some View {
        Text(userName)
        
        
        
    }
    
    
}


#Preview {
    ProfileView()
//        .modelContainer(for: SeekData, inMemory: true)
}
