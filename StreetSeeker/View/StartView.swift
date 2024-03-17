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
    @State private var navigationNum: Int = 0
    
    let userName: String = UserDefaultsKey.userName.get() ?? "no name"
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width        
        
        
        NavigationStack(path: $navigationPath) {
            ZStack {
                Image(.icon)
                    .resizable()
                    .scaledToFill()
                
                Rectangle()
                    .background(.black)
                    .opacity(0.1)
                
                VStack {
                    Text("Street Seeker")
                        .font(.system(size: 50, weight: .heavy))
                        .foregroundColor(.black)
                        .padding(.bottom, 80)
                        .shadow(color: .gray, radius: 15)
                    
                    
                    VStack {
                        NavigationLink(value: pathManager.setting) {
                            Text("始める")
                                .frame(width: screenWidth / 1.5, height: 90)
                                .font(.title)
                        }
                        .buttonStyle(OriginalButton())
                        .shadow(color: .black, radius: 10)
                        .padding(10)
                        
//                        NavigationLink(value: pathManager.enterRoomView) {
//                            Text("友達と")
//                                .frame(width: screenWidth / 1.5, height: 90)
//                                .font(.title)
//                        }
//                            .foregroundColor(.black)
//                            .background(.image)
//                            .cornerRadius(15)
//                            .shadow(color: .black, radius: 10)
//                            .padding(10)
                        
                        NavigationLink(value: pathManager.profile) {
                            Text("プロフィール")
                                .frame(width: screenWidth / 1.5, height: 90)
                                .font(.title)
                        }
                            .foregroundColor(.black)
                            .background(.image)
                            .cornerRadius(15)
                            .shadow(color: .black, radius: 10)
                            .padding(10)
                        
                    }
                    .navigationDestination(for: pathManager.self) { path in
                        if path == .setting {
                            SettingView(navigationPath: $navigationPath)
                        } else if path == .enterRoomView {
                            EnterRoomView()
                        } else if path == .profile {
                            ProfileView()
                        }
                    }
                    
                    Text("※危険な場所や私有地には入らないでください")
                        .foregroundColor(.black)
                }
            }
            
            
        } //NavigationStack
        .task {
            
        }
        
        
    }
    
    private func transition(value: String) {
        
        navigationPath.append(value)
        
    }
    
    enum pathManager: String {
        case setting
        case enterRoomView
        case profile
    }
}

#Preview {
    StartView()
//        .modelContainer(for: SeekData.self, inMemory: true)
}
