//
//  StartView.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/02/14.
//

import SwiftUI
import SwiftData

struct StartView: View {
    
    @Environment(\.modelContext) private var context
    
//    private var userData: [UserData]
    
    @State private var navigationPath: NavigationPath = .init()
    
    let userName: String = UserDefaultsKey.userName.get() ?? "no name"
    
    var body: some View {
        let screenSize = UIScreen.main.bounds.size
        let screenWidth = screenSize.width
        
        
        
        NavigationStack(path: $navigationPath) {
            ZStack {
                Image(.icon)
                
                Rectangle()
                    .background(.black)
                    .opacity(0.1)
                
                VStack {
                    Text("Street Seeker")
                        .font(.system(size: 50, weight: .heavy))
                        .foregroundColor(.black)
                        .padding(.bottom, 80)
                        .shadow(color: .gray, radius: 15)
                    
                    Button(action: {
                        navigationPath.append(pathManager.setting)
                    }, label: {
                        Text("始める")
                            .frame(width: screenWidth / 1.5, height: 90)
                            .font(.title)
                    })
//                    NavigationLink("始める", value: pathManager.setting)
                    .navigationDestination(for: pathManager.self) {_ in
                        SettingView(navigationPath: $navigationPath)
                    }

//                    NavigationLink(destination: SettingView()) {
                        
//                    Button(action: {
//                        transition(value: NavigationManager.setting.rawValue)
//                    }, label: {
//                        Text("始める")
//                            .frame(width: screenWidth / 1.5, height: 90)
//                            .font(.title)
//                    })
                    
//                    NavigationLink(destination: SettingView(navigationPath: $navigationPath)) {
//                        Text("始める")
//                            .frame(width: screenWidth / 1.5, height: 90)
//                            .font(.title)
//                    }
                    
                    .foregroundColor(.black)
                    .background(.image)
                    .cornerRadius(15)
                    .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding(10)
                    
                                        
                        
                    
                    Button(action: {
                        navigationPath.append(pathManager.setting)
                    }, label: {
                        Text("プロフィール")
                            .frame(width: screenWidth / 1.5, height: 90)
                            .font(.title)
                    })
//                    NavigationLink("始める", value: pathManager.setting)
                    .navigationDestination(for: pathManager.self) {_ in
                        ProfileView()
                    }
                    .foregroundColor(.black)
                    .background(.image)
                    .cornerRadius(15)
                    .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding(10)
                    
                    
//                    NavigationLink(destination: EnterRoomView()) {
//                        Text("みんなで")
//                            .frame(width: screenWidth / 1.5, height: 90)
//                            .foregroundColor(.black)
//                            .background(.image)
//                            .cornerRadius(15)
//                            .shadow(color: .black, radius: 10)
//                            .padding(10)
//                    }
//
//                    NavigationLink(destination: ProfileView()) {
//                        Text("プロフィール")
//                            .frame(width: screenWidth / 1.5, height: 90)
//                            .foregroundColor(.black)
//                            .background(.image)
//                            .cornerRadius(15)
//                            .shadow(color: .black, radius: 10)
//
//                            .padding(10)
//                    }
                    Text("※危険な場所や私有地には入らないでください")
                        .foregroundColor(.black)
                }
            }
            
            
        } //NavigationStack
        .onAppear {
//            if userData == [] {
//                
//            }
        }
        
        
    }
    
    private func transition(value: String) {
        
        navigationPath.append(value)
        
    }
    
    enum pathManager: String {
        case setting
    }
}

#Preview {
    StartView()
//        .modelContainer(for: SeekData.self, inMemory: true)
}
