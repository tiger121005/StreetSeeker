//
//  SettingView.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import SwiftUI
import SwiftData
import RangeUISlider
import MapKit

struct SettingView: View {
    
    let manager = SliderManager.shared
    
    @State private var minValue: Int = 2
    @State private var maxValue: Int = 15
    
    @State private var segue = false
    
    @Binding var navigationPath: NavigationPath
    
    @ObservedObject var locationManager = LocationManager()
    
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        
        let screenSize = UIScreen.main.bounds.size
        let screenWidth = screenSize.width
        
//        NavigationStack(path: $navigationPath) {
            VStack {
                Text("探す範囲を指定しよう！")
                    .padding(.bottom, 40)
                    .font(.title)
                    .navigationTitle("設定")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.image, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.light, for: .navigationBar)
                
                HStack {
                    Text(String(manager.value(value: minValue)))
                        .font(.title)
//                        .fontWeight(.bold)
                    Text(" ~ ")
                    Text(String(manager.value(value: maxValue)))
                        .font(.title)
//                        .fontWeight(.bold)
                    
                    Text("m")
                    
                }
                
                CustomSlider(minValue: $minValue, maxValue: $maxValue)
                    .padding(30)
                    .frame(height: 30)
                
                HStack {
                    Text("500m")
                        .font(.title3)
                        .padding(.leading, 10)
                    Spacer()
                    Text("5000m")
                        .font(.title3)
                        .padding(.trailing, 10)
                }
                
                Map(interactionModes: []) {
                    MapCircle(center: locationManager.location.coordinate, radius: CLLocationDistance(manager.value(value: maxValue)))
                        .foregroundStyle(.image.opacity(0.3))
                    MapCircle(center: locationManager.location.coordinate, radius: CLLocationDistance(manager.value(value: minValue)))
                        .foregroundStyle(.image.opacity(1))
                }
                    .frame(height: 300)
                    
                
                
                Button(action: {
                    goPreview()
                }, label: {
                    Text("画像を表示")
                        .frame(width: screenWidth / 2, height: 70)
                        .font(.title2)
                })
                .navigationDestination(for: pathManager.self) {_ in
                    PreviewView(distance: Double(manager.value(value: minValue))...Double(manager.value(value: maxValue)), navigationPath: $navigationPath)
                }
                .buttonStyle(OriginalButton())
//                .padding(.top, 300)
                
            }
            .onAppear() {
                minValue = Int(UserDefaultsKey.minDistance.get() ?? "2") ?? 2
                maxValue = Int(UserDefaultsKey.maxDistance.get() ?? "15") ?? 15
                
                //UserDefaultsで前の値が保存されてい場合
                if maxValue >= 100 {
                    maxValue = 15
                }
            }
            
    }
    
    
    private func transition(value: String) {
        navigationPath.append(value)
        print(navigationPath)
    }
    
    private func goPreview() {
        UserDefaultsKey.minDistance.set(value: String(minValue))
        UserDefaultsKey.maxDistance.set(value: String(maxValue))
        navigationPath.append(pathManager.previewView)
    }
    
    enum pathManager: String {
        case previewView
    }
}

#Preview {
    
    SettingView(navigationPath: .constant(NavigationPath.init()))
//        .modelContainer(for: SeekData.self, inMemory: true)
}

