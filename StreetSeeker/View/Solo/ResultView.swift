//
//  ResultView.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import SwiftUI
import MapKit
import SwiftData

struct ResultView: View {
    
    @Binding var navigationPath: NavigationPath
    
    @Query private var seekData: [SeekData]
    
    @State private var position: MapCameraPosition = .automatic
    
    var location: CLLocationCoordinate2D
    var time: Int
    var steps: Int
    var walkDistance: Int
    var result: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        if result {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.red, .lightRed]), startPoint: .top, endPoint: .bottom)
                    .toolbar(.hidden, for: .navigationBar)
                    .navigationBarBackButtonHidden()
                    
                
                VStack {
                    Text("クリア！")
                        .font(.system(size: 60, weight: .heavy))
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .padding(.bottom, 10)
                    
                    Map(position: $position) {
                        MapPolygon(coordinates: manager.polygonCoordinates(location: location))
                            .foregroundStyle(.image.opacity(0.5))
                            .stroke(lineWidth: 2)
                            .mapOverlayLevel(level: .aboveLabels)
                    }
                        .mapStyle(.imagery(elevation: .realistic))
                        .frame(width: screenWidth * 0.7, height: screenWidth * 0.7)
                        .mapCameraKeyframeAnimator(trigger: position) {_ in
                            KeyframeTrack(\MapCamera.distance) {
                                CubicKeyframe(150, duration: 0.3)
                            }
                        }
                    
                    DataText(text: "タイム: \(manager.tranceSecond(second: time))")
                    DataText(text: "歩数: \(steps)")
                    DataText(text: "距離: \(walkDistance)m")
                        .padding(.bottom, 10)
                    
                    
                    Text("色々な場所でプレイしてみてね")
                        .font(.title3)
                    
                    Button(action: {
                        navigationPath.removeLast(4)
                    }, label: {
                        Text("最初の画面に戻る")
                            .frame(width: screenWidth / 2, height: 70)
                            .font(.title2)
                    })
                    .buttonStyle(OriginalButton())
                    .padding(.top, 30)
                }
                
                
            }
            .onAppear() {
                save()
                
            }
            .task {
                position = .camera(MapCamera(centerCoordinate: location, distance: 150))
            }
        } else {
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.darkBlue, .lightBlue]), startPoint: .top, endPoint: .bottom)
                    .toolbar(.hidden, for: .navigationBar)
                    .navigationBarBackButtonHidden()
                
                VStack {
                    Text("ざんねん...")
                        .foregroundColor(.white)
                        .font(.system(size: 60, weight: .heavy))                .fontWeight(.bold)
                        .padding(.bottom, 40)
                    
                    Text("もっと中心部に近づいてみてね")
                        .font(.title3)
                        .foregroundStyle(.white)
                    
                    Button(action: {
                        navigationPath.removeLast()
                    }, label: {
                        Text("もう一度探す")
                            .frame(width: screenWidth / 2, height: 70)
                            .font(.title2)
                    })
                    .buttonStyle(OriginalButton())
                    .padding(.top, 70)
                    
                    
                }
            }
            
        }

    }
    
    func save() {
        let item = SeekData(latitude: location.latitude,
                            longitude: location.longitude,
                            time: time,
                            distance: walkDistance,
                            steps: steps,
                            date: Date())
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            print("Error save")
        }
    }

        
}

#Preview {
    ResultView(navigationPath: .constant(NavigationPath.init()), location: .defaultLocation, time: 9473, steps: 11000, walkDistance: 1000, result: true)
//        .modelContainer(for: SeekData.self, inMemory: true)
}

