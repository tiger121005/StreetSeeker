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
    
    
    @State private var seekData: [SeekData] = []
    @State private var allSteps: Int = 0
    @State private var allDistance: Int = 0
    
    let context = try! ModelContext(for: SeekData.self)
    // FetchDescriptor で predicate を省略すると全件取得になる
    let fetchDescriptor = FetchDescriptor<SeekData>()

    
    init() {
        userName = userData.userName
        
    }
    
    
    var body: some View {
        VStack {
            
            Text(userName)
            
            Text("総歩数: \(allSteps)")
            
            Text("総距離: \(allDistance)")
            
            
        }
        .onAppear() {
            do {
                seekData = try context.fetch(fetchDescriptor)
            } catch {
                print("error get")
                return
            }
            allSteps = 0
            allDistance = 0
            for data in seekData {
                allSteps += data.steps
                allDistance += data.distance
            }
            
            print(seekData)
        }
        
    }
        
    
    
}


#Preview {
    ProfileView()
        .modelContainer(for: SeekData, inMemory: true)
}
