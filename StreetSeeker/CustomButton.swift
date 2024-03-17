//
//  OriginalButton.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/03/14.
//

import SwiftUI

struct OriginalButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .background(.image)
            .cornerRadius(15)
    }
}

struct WhiteFrameButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.text)
            .overlay(RoundedRectangle(cornerRadius: 15)
                .stroke(Color.text, lineWidth: 2))
    }
}
