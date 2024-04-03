//
//  NameCard.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/03/24.
//

import SwiftUI

struct NameCard: View {
    
    var seekData: [SeekData]
    
    var rank: Rank = manager.rank
    
    @State var userName = ""
    @State var alertPresented = false
    
    var body: some View {
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
        .onAppear() {
            userName = UserDefaultsKey.userName.get() ?? "no name"
            if userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                userName = "no name"
            }
        }
    }
}
