//
//  CustomSlider.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/03/24.
//

import SwiftUI

struct CustomSlider: View {
    let manager = SliderManager.shared
    
    @Binding var minValue: Int
    @Binding var maxValue: Int
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let xInterval = screenWidth / CGFloat(manager.num)
            
            VStack {
                
                ZStack {
                    
                    Bar()
                        .frame(width: screenWidth, height: 5)
                        .position(CGPoint(x: screenWidth / 2, y: 0))
                    
                    RangeBar(min: $minValue, max: $maxValue, screenWidth: screenWidth)
                        .frame(width: CGFloat(maxValue - minValue) * xInterval,
                               height: 5)
                    
                        .position(CGPoint(x: CGFloat(minValue + maxValue) * xInterval / 2, y: 0))
                    
                    Knob()
                        .position(CGPoint(x: CGFloat(minValue) * xInterval, y: 0))
                        .gesture(dragGesture(name: .min, screenWidth: screenWidth))
                    
                    
                    Knob()
                        .position(CGPoint(x: CGFloat(maxValue) * xInterval, y: 0))
                        .gesture(dragGesture(name: .max, screenWidth: screenWidth))
                    
                }
                
                .frame(height: 30)
                .onAppear() {
                }
                    
            }
        }
    }
    
    func dragGesture(name: SliderName, screenWidth: CGFloat) -> some Gesture {
        return DragGesture()
            .onChanged { gesture in
                let xInterval = screenWidth / CGFloat(manager.num)
                if name == .min {
                    minValue = Int(round(gesture.location.x / xInterval))
                    if minValue >= maxValue {
                        minValue = maxValue - 1
                    } else if minValue <= manager.minLimitInt {
                        minValue = manager.minLimitInt
                        
                    }
                    
                } else {
                    maxValue = Int(round(gesture.location.x / xInterval))
                    if maxValue <= minValue {
                        maxValue = minValue + 1
                    } else if maxValue >= manager.maxLimitInt {
                        maxValue = manager.maxLimitInt
                    }
                    
                }
            }
    }
    
    
}



struct Knob: View {
    var body: some View {
        Circle()
            .frame(width: 25, height: 25)
            .foregroundColor(.accentColor)
            
    }
    
    
    

}

struct Bar: View {
    var body: some View {
        VStack {
            Rectangle()
                .cornerRadius(2)
                .foregroundColor(.gray)
        }
    }
}

struct RangeBar: View {
    @Binding var min: Int
    @Binding var max: Int
    var screenWidth: CGFloat
    
    
    var body: some View {
        VStack {
            Rectangle()
                .cornerRadius(2)
                .foregroundColor(.image)
        }
        
        
    }
}

struct SliderTestView: View {
    let manager = SliderManager.shared
    @State private var minValue: Int = sliderManager.startMin
    @State private var maxValue: Int = sliderManager.startMax
    var body: some View {
        VStack {
            
            HStack {
                Text(String(manager.value(value: minValue)))
                Text("~")
                Text(String(manager.value(value: maxValue)))
            }
            CustomSlider(minValue: $minValue, maxValue: $maxValue)
                .padding(20)
        }
    }
}

struct SliderView_Preview: PreviewProvider {
    
    static var previews: some View {
        SliderTestView()
    }
}
