//
//  StampView.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/03/24.
//

import SwiftUI

struct StampView: View {
    
    var value: [SeekData]
    var dataCount: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.text)
                .cornerRadius(20)
            
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
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    Spacer()
                    Text("ランクアップまで \(dataCount)/\(manager.rank.nextBorder)")
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
}
