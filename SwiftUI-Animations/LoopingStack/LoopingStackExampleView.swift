//
//  LoopingStackExampleView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/23.
//

import SwiftUI

struct LoopingStackExampleView: View {
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            LoopingStack(maxTranslationWidth: width) {
                ForEach(0 ..< 5, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.random)
                        .frame(width: 250, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 420)
      
    }
}
