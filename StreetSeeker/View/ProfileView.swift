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
    @State private var userName: String = ""
    @State private var allSteps: Int = 0
    @State private var allDistance: Int = 0
    @State private var dataCount: Int = 0
    @State private var rank: Rank = .biginner
    @State private var alertPresented = false
    @State private var pageSelected: Int = 0
    
    
    //MARK: - View
    
    var body: some View {
        VStack {
            nameCard()
            
            
            TabView(selection: $pageSelected) {
                if seekData.count != 0 {
                    ForEach(devidedData, id: \.self) { value in
                        stampView(value: value)
                    }
                } else {
                    stampView(value: [])
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
            userName = UserDefaultsKey.userName.get() ?? "no name"
            if userName.trimmingCharacters(in: .whitespaces).isEmpty {
                userName = "no name"
                
            }
            
            allSteps = 0
            allDistance = 0
            
            let sortedData = seekData.sorted { $0.date < $1.date }
            
            for data in sortedData {
                allSteps += data.steps
                allDistance += data.distance
            }
            
            var data = sortedData
            while data.count != 0 {
                if data.count < 10 {
                    devidedData.append(data)
                    data = []
                } else {
                    let ten = Array(data.prefix(10))
                    data.removeSubrange(0...9)
                    devidedData.append(ten)
                }
            }
            
            devidedData.reverse()

            
            dataCount = seekData.count
            
            if dataCount < 10 {
                rank = .biginner
            } else if dataCount < 20 {
                rank = .bronze
            } else if dataCount < 40 {
                rank = .silver
            } else if dataCount < 60 {
                rank = .gold
            } else  {
                rank = .platinum
            }
            
            print(seekData)
        }
        
    }
    
    
    
    
    func nameCard() -> some View {
        
        ZStack {
            LinearGradient(colors: rank.color, startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                .cornerRadius(15)
            VStack {
                Text(rank.rawValue)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(rank.textColor)
                    .padding(10)
                
                ZStack {
                    Text(userName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(rank.textColor)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            alertPresented = true
                        }, label: {
                            Image(uiImage: .pencil)
                        })
                        .alert("名前の変更", isPresented: $alertPresented) {
                            TextField("名前を変更", text: $userName)
                            
                            Button("キャンセル", role: .cancel) {
                                
                            }
                            
                            Button("変更", role: .none) {
                                if userName.trimmingCharacters(in: .whitespaces).isEmpty {
                                    userName = "no name"
                                    
                                }
                                UserDefaultsKey.userName.set(value: userName)
                                
                            }
                        }
                        .padding(.trailing, 10)
                    }
                }
            }
        }
        .aspectRatio(2 / 1, contentMode: .fit)
        .padding(20)
        
    }
        
    func stampView(value: [SeekData]) -> some View {
        
        
        ZStack {
            Rectangle()
                .foregroundColor(.text)
                .cornerRadius(20)
                .padding(.horizontal, 7)
            
            VStack {
                Grid() {
                    GridRow {
                        ForEach(0..<5) { number in
                            
                            if number < value.count {
                                VStack {
                                    
                                    NavigationLink(destination: DataView(data: value[number]), label: {
                                        Image(.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                        })
                                    Text(manager.dateToString(date: value[number].date))
                                        .foregroundStyle(Color.background)
                                        .font(.footnote)
                                }
                            } else {
                                VStack {
                                    Color.gray
                                        .clipShape(Circle())
                                    Text(" ")
                                        .font(.footnote)
                                }
                            }
                        }
                    }
                    GridRow {
                        ForEach(5..<10) { number in
                            if number < value.count {
                                VStack {
                                    
                                    NavigationLink(destination: DataView(data: value[number]), label: {
                                    
                                        Image(.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                        })
                                    
                                    Text(manager.dateToString(date: value[number].date))
                                        .foregroundStyle(Color.background)
                                        .font(.footnote)
                                }
                            } else {
                                VStack {
                                    Color.gray
                                        .clipShape(Circle())
                                    Text(" ")
                                        .font(.footnote)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                HStack {
                    Spacer()
                    Text("ランクアップまで \(dataCount)/\(rank.nextBorder)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.image)
                        .padding(.trailing, 20)
                        .padding(.bottom, 10)
                }
            }
        }
        .aspectRatio(5 / 3, contentMode: .fit)
        
    }
    
    enum Rank: String {
        case platinum = "Platinum"
        case gold = "Gold"
        case silver = "Silver"
        case bronze = "Bronze"
        case biginner = "Biginner"
        
        var color: [Color] {
            switch self {
            case .platinum:
                return [Color(hex: 0xff6161),
                        Color(hex: 0xe9b22d),
                        Color(hex: 0xc0ca4b),
                        Color(hex: 0x35b338),
                        Color(hex: 0x566ef3),
                        Color(hex: 0x9a27ee)]
            case .gold:
                return [Color(hex: 0xDBB400),
                        Color(hex: 0xEFAF00),
                        Color(hex: 0xF5D100),
                        Color(hex: 0xE0CA82),
                        Color(hex: 0xD1AE15),
                        Color(hex: 0xDBB400)]
            case .silver:
                return [Color(hex: 0x70706F),
                        Color(hex: 0x7D7D7A),
                        Color(hex: 0xB3B6B5),
                        Color(hex: 0x8E8D8D),
                        Color(hex: 0xB3B6B5),
                        Color(hex: 0xA1A2A3)]
            case .bronze:
                return [Color(hex: 0x804A00),
                        Color(hex: 0x9C7A3C),
                        Color(hex: 0xB08D57),
                        Color(hex: 0x895E1A),
                        Color(hex: 0x804A00),
                        Color(hex: 0xB08D57)]
            case .biginner:
                return [.image]
            }
        }
        
        var textColor: Color {
            switch self {
                
            case .platinum:
                return .black
            case .gold:
                return .black
            case .silver:
                return .white
            case .bronze:
                return .white
            case .biginner:
                return .black
            }
        }
        
        var nextBorder: String {
            switch self {
            case .platinum:
                return "max"
            case .gold:
                return "60"
            case .silver:
                return "40"
            case .bronze:
                return "20"
            case .biginner:
                return "10"
            }
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
