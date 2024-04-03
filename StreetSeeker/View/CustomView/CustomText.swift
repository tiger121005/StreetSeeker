//
//  CustomText.swift
//  StreetSeeker
//
//  Created by 伊藤汰海 on 2024/03/24.
//

import SwiftUI

struct DataText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}
