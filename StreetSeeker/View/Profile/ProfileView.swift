//
//  ProfileView.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/15.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    
    @Query private var seekData: [SeekData]
    @State private var devidedData: [[SeekData]] = []
    @State private var allSteps: Int = 0
    @State private var allDistance: Int = 0
    @State private var rank: Rank = .beginner
    @State private var alertPresented = false
    @State private var pageSelected: Int = 0
    
    
    //MARK: - View
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        
        VStack {
            NameCard(seekData: seekData)
                .frame(width: screenWidth * 0.9)
            
            TabView(selection: $pageSelected) {
                if seekData.count != 0 {
                    ForEach(devidedData, id: \.self) { value in
                        StampView(value: value, dataCount: seekData.count)
                            .frame(width: screenWidth * 0.95)
                    }
                } else {
                    StampView(value: [], dataCount: seekData.count)
                        .frame(width: screenWidth * 0.95)
                }
                
            }
            .aspectRatio(5 / 3, contentMode: .fit)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Text("総歩数: \(allSteps)")
                .font(.title)
                .padding(.top, 20)
            
            Text("総距離: \(allDistance)m")
                .font(.title)
            
            Spacer()
        }
        .onAppear() {
            
            allSteps = manager.steps
            allDistance = manager.distance
            
            devidedData = manager.devidedData
            
        }
        
    }
    
}


@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: SeekData.self)
        var sampleData: [SeekData] = []
        for _ in 0...16 {
            sampleData.append(SeekData(latitude: 135, longitude: 35, time: 13762, distance: 10382, steps: 14937, date: Date()))
        }
        
        for data in sampleData {
            container.mainContext.insert(data)
        }
        
        return container
        
    } catch {
        fatalError("Failed to create container")
    }
}()

#Preview {
    MainActor.assumeIsolated {
        ProfileView()
            .modelContainer(previewContainer)
    }
}
