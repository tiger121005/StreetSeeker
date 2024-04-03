//
//  DataView.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/16.
//

import SwiftUI
import MapKit


struct DataView: View {
    var data: SeekData
    
    @State private var position: MapCameraPosition = .automatic
    @State private var searchLocation: CLLocationCoordinate2D = .defaultLocation
    @State private var time: String = "00:00:00"
    @State private var adress: String = ""
    
    var body: some View {
        VStack {
            
            Text(manager.dateToString(date: data.date))
                .font(.title)
                .padding(20)
            
            Text(adress)
                .font(.title2)
            
            Map(position: $position) {
                
                MapPolygon(coordinates: manager.polygonCoordinates(location: searchLocation))
                    .foregroundStyle(.image.opacity(0.5))
                    .mapOverlayLevel(level: .aboveLabels)
                
            }
                .mapStyle(.imagery(elevation: .realistic))
                .mapCameraKeyframeAnimator(trigger: position) {_ in
                    KeyframeTrack(\MapCamera.distance) {
                        CubicKeyframe(200, duration: 0.3)
                    }
                }
                .padding(.horizontal, 20)
            
            HStack {
                
                Button {
                    relocate()
                } label: {
                    Text("元の場所")
                        .font(.title2)
                        .foregroundStyle(.imageText)
                }
            }
            
            dataText(text: "タイム: \(time)")
                .padding(.top, 20)
            dataText(text: "歩数: \(data.steps)")
            dataText(text: "距離: \(data.distance)m")
            
            
            
        }
        .onAppear() {
            searchLocation = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            
            
            time = manager.tranceSecond(second: data.time)
            
            
            let location = CLLocation(latitude: data.latitude, longitude: data.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                var administrativeArea = ""
                var locality = ""
                var subLocality = ""
                
                let place = placemarks?.first
                
                if let adress = place?.administrativeArea {
                    administrativeArea = adress
                }
                
                if let adress = place?.locality {
                    locality = adress
                }
                
                if let adress = placemarks?.first?.subLocality {
                    subLocality = adress
                }
                
                self.adress = administrativeArea + locality + subLocality
                
            }
        }
        
        .task {
            position = .camera(MapCamera(centerCoordinate: searchLocation,
                                         distance: 200,
                                        pitch: 0))
        }
        
    }
    
    
    func dataText(text: String) -> some View {
        Text(text)
            .foregroundStyle(.white)
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    
    func relocate() {
        position = .camera(MapCamera(centerCoordinate: searchLocation,
                                     distance: 200,
                                     heading: 0,
                                     pitch: 0))
    }
    
}

#Preview {
    DataView(data: SeekData(latitude: 135, longitude: 35, time: 10837, distance: 8937, steps: 9582, date: Date()))
}
