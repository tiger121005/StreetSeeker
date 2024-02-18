//
//  Manager.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import SwiftUI
import MapKit
import SwiftData

let manager = Manager.shared


//MARK: - Manager

class Manager {
    
    static var shared = Manager()
    
    @ObservedObject var locationManager = LocationManager()
    
    
    func meterPerLongitudeDegrees(latitude: Double) -> Double {
        let l = 6376136.0
        let meterPerLongitudeDegrees = 180 / (l * cos((latitude / 180) * .pi) * Double.pi)
        return meterPerLongitudeDegrees
    }
    
    func randomLocation(distanceRange: ClosedRange<Double>) -> CLLocationCoordinate2D {
        
        let currentLocation = locationManager.location.coordinate
        let radius = Double.random(in: 0...2*Double.pi)
        let distance = Double.random(in: distanceRange)
        let distanceX = distance * cos(radius)
        let distanceY = distance * sin(radius)
        print("----------------")
        print("distanceX: ", distanceX)
        print("distanceY: ", distanceY)
        let latitudeDifference = material.meterPerLatitudeDegrees * distanceY
        print("latitudeDifference: ", latitudeDifference)
        let latitude = latitudeDifference + currentLocation.latitude
        let longitudeDifference = manager.meterPerLongitudeDegrees(latitude: latitude) * distanceX
        print("longitudeDegressPerMeter: ", manager.meterPerLongitudeDegrees(latitude: latitude))
        print("longitudeDifference: ", longitudeDifference)
        let longitude = longitudeDifference + currentLocation.longitude
        print("searchLocation", latitude, longitude)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        
    }
    
    
    func polygonCoordinates(location: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        let polygonSideLength = material.polygonSideLength
        let meterPerLatitudeDegrees = material.meterPerLatitudeDegrees
        let meterPerLongitudeDegrees = meterPerLongitudeDegrees(latitude: location.latitude)
        
        let top = Double(location.latitude) + (meterPerLatitudeDegrees * polygonSideLength / 2)
        let bottom = Double(location.latitude) - (meterPerLatitudeDegrees * polygonSideLength / 2)
        let right = Double(location.longitude) + (meterPerLongitudeDegrees * polygonSideLength / 2)
        let left = Double(location.longitude) - (meterPerLongitudeDegrees * polygonSideLength / 2)
            
        return [CLLocationCoordinate2D(latitude: top, longitude: right),
                CLLocationCoordinate2D(latitude: top, longitude: left),
                CLLocationCoordinate2D(latitude: bottom, longitude: left),
                CLLocationCoordinate2D(latitude: bottom, longitude: right)]

        
    
    }
    
    func tranceSecond(second: Int) -> String {
        var hour = String(Int(second / 3600))
        var remain = second % 3600
        var minute = String(Int(remain / 60))
        remain = remain % 60
        var second = String(remain)

        if second.count == 1 {
            second = "0" + second
        }
        if minute.count == 1 {
            minute = "0" + minute
        }
        if hour.count == 1 {
            hour = "0" + hour
        }
        return hour + ":" + minute + ":" + second
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yy/MM/dd"
        return dateFormatter.string(from: date)
    }
}


//MARK: - NavigationManager

enum NavigationManager: String {
    case setting = "SetttingView"
    case preview = "PreviewView"
    case seek = "SeekView"
    case result = "ResultView"
    case enterRoom = "EnterRoomView"
    case profile = "ProfileView"
    
    
}


//MARK - UserDefaultsKey

enum UserDefaultsKey: String {
    case userName = "userName"
    
    
    func get() -> String? {
        return UserDefaults.standard.string(forKey: self.rawValue)
    }

    func set(value: String) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }

    func remove() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
    
    func register() {
        UserDefaults.standard.register(defaults: ["userName": "no name"])
    }
}


//MARK: - ModelContext

public extension ModelContext {
    enum StorageType {
        case inMemory
        case file
    }
    
    
    convenience init(
        for types: any PersistentModel.Type...,
        storageType: StorageType = .inMemory,
        shouldDeleteOldFile: Bool = true,
        fileName: String = #function
    ) throws {
        // 1. モデル定義のメタタイプで Schema を初期化
        let schema = Schema(types)
        
        
        
        let sqliteURL = URL.documentsDirectory
            .appending(component: fileName)
            .appendingPathExtension("sqlite")
        
        // ファイルストレージの DB を削除するかで
        // これは動作確認をする上で設けています。
        //        if shouldDeleteOldFile {
        //            let fileManager = FileManager.default
        //
        //            if fileManager.fileExists(atPath: sqliteURL.path) {
        //                try fileManager.removeItem(at: sqliteURL)
        //            }
        //        }
        
        // 2. Schema で ModelConfiguration を初期化
        let modelConfiguration: ModelConfiguration = {
            switch storageType {
            case .inMemory:
                ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: true
                )
            case .file:
                ModelConfiguration(
                    schema: schema,
                    url: sqliteURL
                )
            }
        }()
        
        // 3. ModelConfigurationでModelContainerを初期化
        let modelContainer = try ModelContainer(
          for: schema,
          configurations: [modelConfiguration]
        )
        
        // 4. ModelContainerでModelontextを初期化
        self.init(modelContainer)
        
        
//        func fetch<Model>(
//          for type: Model.Type
//        ) throws -> [Model] where Model: PersistentModel {
//          try fetch(.init())
//        }
//        
//        func fetchCount<Model>(
//          for type: Model.Type
//        ) throws -> Int where Model: PersistentModel {
//          try fetchCount(FetchDescriptor<Model>())
//        }
        
    }
    
}


extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xff) / 255,
                  green: Double((hex >> 08) & 0xff) / 255,
                  blue: Double((hex >> 00) & 0xff) / 255,
                  opacity: alpha)
    }
}

