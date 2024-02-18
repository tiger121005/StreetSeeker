//
//  SeekView.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import SwiftUI
import CoreMotion
import MapKit

struct SeekView: View {
    
    var searchLocation: CLLocationCoordinate2D
    
    
    let altitudeBeforeAnimation = material.altitudeBeforeAnimation
    
    let pedometer = CMPedometer()
    
    @State private var position: MapCameraPosition = .automatic
    @State private var mapHeading: Double = 0.0
    @State private var mapPitch: Double = 0.0
    @State private var animationTrigger: Bool = false
    @State private var timer: String = "00:00:00"
    @State private var secondTimer: Int = 0
    @State private var runTimer: Bool = true
    @State private var viewDidLoad = true
    @State private var showAlert: Bool = false
    @State private var above: Bool = true
    @State private var steps: Int = 0
    @State private var walkDistance: Double = 0
    
    @Binding var navigationPath: NavigationPath
    
    @ObservedObject var locationManager = LocationManager()
    
    @State private var timeManager: Timer!
    
    
    
    var body: some View {
        
        let screenWidth = UIScreen.main.bounds.width
        
        VStack {
            
            ZStack(alignment: .bottom) {
                
                
                Text(timer)
                    .font(.system(size: 65, weight: .black))
                    .fontWidth(.compressed)
                    .frame(height: 55)
                
                    .toolbar(.hidden, for: .navigationBar)
                    .navigationBarBackButtonHidden()
                
                HStack {
                    Button(action: {
                        changePerspective()
                    }, label: {
                        if above {
                            Text("斜め")
                                .frame(width: 60, height: 40)
                                .font(.title3)
                                .foregroundColor(.text)
                                .overlay(RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.text, lineWidth: 2))
                                
                        } else {
                            Text("真上")
                                .frame(width: 60, height: 40)
                                .font(.title3)
                                .foregroundColor(.text)
                                .overlay(RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.text, lineWidth: 2))
                        }
                    })
                    .padding(.leading, 5)
                    
                    Spacer()
                    
                    Button(action: {
                        rotateMap()
                    }, label: {
                        Text("回転")
                            .frame(width: 60, height: 40)
                            .font(.title3)
                            .foregroundColor(.text)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.text, lineWidth: 2))
                    })
                    .padding(.trailing, 5)
                }
                
            }
            .padding(.top, 40)
            
            Map(position: $position,
                interactionModes: []) {
                
                MapPolygon(coordinates: manager.polygonCoordinates(location: searchLocation))
                    .foregroundStyle(.image.opacity(0.5))
                    .mapOverlayLevel(level: .aboveLabels)
                
            }
                .padding(.vertical, 10)
                .mapStyle(.imagery(elevation: .realistic))
                .mapCameraKeyframeAnimator(trigger: position) {_ in
                    KeyframeTrack(\MapCamera.distance) {
                        CubicKeyframe(200, duration: 2.0)
                    }
                }
            
            //            NavigationLink(destination: ResultView(navigationPath: $navigationPath, result: judgeCorrect())) {
            
            Text("緑の四角に入ったらボタンを押してね")
                .font(.title3)
                .foregroundColor(.text)
            
            Button(action: {
                navigationPath.append(pathManager.result)
            }, label: {
                Text("ここ！")
                    .font(.title2)
                    .frame(width: screenWidth / 2, height: 70)
                    .foregroundColor(.black)
                    .background(.image)
                    .cornerRadius(15)
                
            })
            .navigationDestination(for: pathManager.self) {_ in
                ResultView(navigationPath: $navigationPath, location: searchLocation, time: secondTimer, steps: steps, walkDistance: Int(round(walkDistance)), result: judgeCorrect())
            }
            
            Button(action: {
                showAlert = true
                
            }, label: {
                Text("ギブアップ")
                    .font(.title3)
                    .foregroundStyle(.imageText)
            })
            .alert("ギブアップ", isPresented: $showAlert) {
                Button("キャンセル", role: .cancel) {
                    showAlert = false
                }
                
                Button("ギブアップ", role: .destructive) {
                    timerStop()
                    pedometer.stopUpdates()
                    steps = 0
                    navigationPath.removeLast()
                    
                }
            } message: {
                Text("ギブアップしますか")
            }
            .padding(10)
        }
        .onAppear {
            if viewDidLoad {
                steps = 0
                startCountStep()
//                if let timeManager {
//                    timerStop()
//                }
                timer = "00:00:00"
                secondTimer = 0
                timerStart()
                viewDidLoad = false
            }
            
            
        }
        .task {
            position = .camera(MapCamera(centerCoordinate: searchLocation,
                                         distance: altitudeBeforeAnimation,
                                         heading: mapHeading,
                                         pitch: mapPitch))
            animationTrigger.toggle()
        }
        
    }
    
    func timerStart() {
        
        runTimer = true
        timeManager = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: runTimer) {_ in
            
            secondTimer += 1
            
            if secondTimer == 391859 { //99:59:59
                timerStop()
            }
            
            timer = manager.tranceSecond(second: secondTimer)
            print(timer)
        }
    }
    
    func timerStop() {
        runTimer = false
        timeManager.invalidate()
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
    
    private func startCountStep() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { (pedometerData, error) in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                guard let data = pedometerData else {
                    return
                }
                steps = data.numberOfSteps.intValue
                walkDistance = data.distance?.doubleValue ?? walkDistance
                
                print("steps", steps)
            }
        }
    }
    
    func judgeCorrect() -> Bool {
        let currentLocation = locationManager.location.coordinate
        let coordinates = manager.polygonCoordinates(location: searchLocation)
        
        let top = coordinates[0].latitude
        let bottom = coordinates[2].latitude
        let right = coordinates[0].longitude
        let left = coordinates[1].longitude
        
        if top >= currentLocation.latitude && bottom <= currentLocation.latitude {
            if right > currentLocation.longitude && left < currentLocation.longitude {
                timerStop()
                pedometer.stopUpdates()
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
    
    enum pathManager: String {
        case result
    }
    
}

//#Preview {
//    SeekView(searchLocation: CLLocationCoordinate2D(latitude: 135, longitude: 35), navigationPath: .constant(NavigationPath.init()))
////        .modelContainer(for: SeekData.self, inMemory: true)
//}

