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
    @State private var currentMinValue: CGFloat = 250
    @State private var currentMaxValue: CGFloat = 750
    
    @State private var segue = false
    
    @Binding var navigationPath: NavigationPath
    
    @ObservedObject var locationManager = LocationManager()
    
    
//    init() {
//        let navigationBar = UINavigationBarAppearance()
//        navigationBar.backgroundColor = .image
//        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
//    }
    
    var body: some View {
        
        let screenSize = UIScreen.main.bounds.size
        let screenWidth = screenSize.width
        
//        NavigationStack(path: $navigationPath) {
            VStack {
                Text("探す範囲を指定しよう！")
                    .padding(.bottom, 20)
                    .font(.title2)
                    .navigationTitle("設定")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.image, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.light, for: .navigationBar)
                
                HStack {
                    Text(String(Int(currentMinValue)))
                        .font(.title3)
                    Text(" ~ ")
                    Text(String(Int(currentMaxValue)))
                        .font(.title3)
                    
                    Text("m")
                    
                }
                
                
                RangeSlider(minValueSelected: $currentMinValue, maxValueSelected: $currentMaxValue)
                
                    .scaleMinValue(250)
                    .scaleMaxValue(5000)
                    .rangeSelectedColor(.image)
                    .rangeNotSelectedColor(.secondary)
                    .barHeight(4)
                    .stepIncrement(250)
                    .defaultValueLeftKnob(250)
                    .defaultValueRightKnob(750)
                    .leftKnobColor(Color.text)
                    .leftKnobWidth(25)
                    .leftKnobHeight(25)
                    .leftKnobCorners(12.5)
                    .rightKnobColor(Color.text)
                    .rightKnobWidth(25)
                    .rightKnobHeight(25)
                    .rightKnobCorners(12.5)
                    .frame(height: 20)
                    .padding(.horizontal, 50)
                
                HStack {
                    Text("250m")
                        .font(.title3)
                        .padding(.leading, 50)
                    Spacer()
                    Text("5000m")
                        .font(.title3)
                        .padding(.trailing, 50)
                }
                
                Button(action: {
                    navigationPath.append(pathManager.previewView)
                }, label: {
                    Text("画像を表示")
                        .frame(width: screenWidth / 2, height: 70)
                        .font(.title2)
                })
                .navigationDestination(for: pathManager.self) {_ in
                    PreviewView(distance: Double(currentMinValue)...Double(currentMaxValue), navigationPath: $navigationPath)
                }
//                NavigationLink(destination: PreviewView(distance: Double(currentMinValue)...Double(currentMaxValue), navigationPath: $navigationPath)) {
//                    Text("画像を表示")
//                        .frame(width: screenWidth / 2, height: 70)
//                        .font(.title)
//                }
                .background(.image)
                .foregroundColor(.black)
                .cornerRadius(15)
                .padding(.top, 300)
                
            }
        
            
            
//        }
    }
    
    
    private func transition(value: String) {
        navigationPath.append(value)
        print(navigationPath)
    }
    
    enum pathManager: String {
        case previewView
    }
}

#Preview {
    
    SettingView(navigationPath: .constant(NavigationPath.init()))
//        .modelContainer(for: SeekData.self, inMemory: true)
}

