//
//  PreviewView.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import SwiftUI
import MapKit
import Foundation

struct PreviewView: View {
    
    var distance: ClosedRange<Double>
    
    let altitudeBeforeAnimation = material.altitudeBeforeAnimation
    
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var yOffset: CGFloat = 0
    @State private var searchLocation: CLLocationCoordinate2D = .defaultLocation
    @State private var viewDidload = true
    @State private var position: MapCameraPosition = .automatic
    @State private var mapStyle: MapStyle = .standard
    @State private var animationTrigger: Bool = false
    @State private var mapHeading: Double = 0.0
    @State private var mapPitch: Double = 0.0
    @State private var reloadActive: Bool = false
    @State private var above: Bool = true
    @State private var showAlert: Bool = false
    
    @Binding var navigationPath: NavigationPath
    
    @ObservedObject var locationManager = LocationManager()
    
    //MARK: - View
    
    var body: some View {
        
        let screenWidth = UIScreen.main.bounds.width
        
        
        Group {
            VStack {
                ZStack {
                    HStack {
                        Spacer(minLength: 70)
                        Button(action: {
                            changeLocation(distanceRange: distance)
                        }, label: {
                            Text("場所を変える")
                                .frame(width: screenWidth / 2, height: 40)
                                .font(.title3)
                                .foregroundColor(reloadActive ? .gray: .imageText)
                                .overlay(RoundedRectangle(cornerRadius: 15)
                                    .stroke(reloadActive ? .gray: .imageText, lineWidth: 2))
                        })
                        .padding(.vertical, 10)
                        .disabled(reloadActive)
                        
                        
                        .navigationTitle("プレビュー")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(.image, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarColorScheme(.light, for: .navigationBar)
                        
                        Spacer(minLength: 70)
                        
                    }
                    HStack {
                        Button(action: {
                            changePerspective()
                        }, label: {
                            if above {
                                Text("斜め")
                                    .frame(width: 60, height: 40)
                                    .font(.title3)
                                    
                            } else {
                                Text("真上")
                                    .frame(width: 60, height: 40)
                                    .font(.title3)
                                    
                            }
                        })
                        .buttonStyle(WhiteFrameButton())
                        .padding(.leading, 5)
                        
                        Spacer()
                        
                        Button(action: {
                            rotateMap()
                        }, label: {
                            Text("回転")
                                .frame(width: 60, height: 40)
                                .font(.title3)
                                
                        })
                        .buttonStyle(WhiteFrameButton())
                    }
                    .padding(.trailing, 5)
                    
                }
                .padding(.top, 10)
                
                Map(position: $position,
                    interactionModes: []) {
                    
                    MapPolygon(coordinates: manager.polygonCoordinates(location: searchLocation))
                        .foregroundStyle(.image.opacity(0.5))
                        .stroke(lineWidth: 2)
                    
                        .mapOverlayLevel(level: .aboveLabels)
                    
                }
                    .mapStyle(.imagery(elevation: .realistic))
                
                    .mapCameraKeyframeAnimator(trigger: position) {_ in
                        KeyframeTrack(\MapCamera.distance) {
                            CubicKeyframe(200, duration: 2.0)
                        }
                    }
                
                    
                
                
                Button(action: {
                    navigationPath.append(pathManager.seek)
                }, label: {
                    Text("探す！")
                        .frame(width: screenWidth / 2, height: 70)
                        .font(.title2)
                })
                .navigationDestination(for: pathManager.self) {_ in
                    SeekView(searchLocation: searchLocation, navigationPath: $navigationPath)
                }
                .buttonStyle(OriginalButton())
                .padding(.vertical, 15)
                
                
//                NavigationLink(destination: SeekView(searchLocation: searchLocation, navigationPath: $navigationPath)) {
//                    Text("ここを探す")
//                        .frame(width: screenWidth / 2, height: 70)
//                        .foregroundColor(.black)
//
//                }
            }
        }
        .alert("現在地を取得できません", isPresented: $showAlert) {
            Button("OK") {
                navigationPath.removeLast()
            }
        } message: {
            Text("設定から位置情報の取得がオフになっていないか確認してください")
        }
        
        .task {
            checkAuth()
            searchLocation = manager.randomLocation(distanceRange: distance)
            position = .camera(MapCamera(centerCoordinate: searchLocation,
                                         distance: altitudeBeforeAnimation,
                                         heading: mapHeading,
                                        pitch: mapPitch))
            zoomin()
            print(navigationPath)
        }
        

    }
    
    
    //MARK: - Method
    func checkAuth() {
        if locationManager.location.coordinate.latitude == 0 && locationManager.location.coordinate.longitude == 0 {
            showAlert = true
        }
    }
    
    func changeLocation(distanceRange: ClosedRange<Double>) {
        
        
        searchLocation = manager.randomLocation(distanceRange: distanceRange)
        
        print("searchLocation: ", searchLocation as Any)
        position = .camera(MapCamera(centerCoordinate: searchLocation,
                                     distance: altitudeBeforeAnimation,
                                     heading: 0,
                                     pitch: 0))
        getSatelliteImage(searchLocation: searchLocation)
        
        zoomin()
        
        
    }
    
    
    func getSatelliteImage(searchLocation: CLLocationCoordinate2D) {
        
        position = .camera(MapCamera(centerCoordinate: searchLocation,
                                     distance: altitudeBeforeAnimation,
                                    pitch: 0))
        mapHeading = 0.0
        print(position)
        
    }
    
    func changeStyle() {
        mapStyle = .imagery(elevation: .realistic)
    }
    
    func rotateMap() {
        mapHeading += 90
        changePosition()
    }
    
    
    func changePerspective() {
        if above {
            mapPitch = 30
        } else {
            mapPitch = 0
        }
        changePosition()
        above.toggle()
    }
    
    func changePosition() {
        position = .camera(MapCamera(centerCoordinate: searchLocation,
                                     distance: 200,
                                     heading: mapHeading,
                                    pitch: mapPitch))
    }
    
    
    func zoomin() {
        animationTrigger.toggle()
        DispatchQueue.global().async {
            reloadActive = true
            print("before 2 second")
            sleep(2)
            reloadActive = false
        }
        
        print("after 2 second")
        
    }

    
    
    enum pathManager: String {
        case seek
    }
    
    
}



#Preview {
    PreviewView(distance: 500...1000, navigationPath: .constant(NavigationPath.init()))
//        .modelContainer(for: SeekData.self, inMemory: true)
}

