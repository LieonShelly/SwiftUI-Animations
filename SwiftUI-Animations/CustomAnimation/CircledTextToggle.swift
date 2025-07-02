//
//  CircledTextToggle.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//

import SwiftUI

struct CircledTextToggle: ViewModifier {
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content.frame(width: 30, height: 30)
            .modifier(CircledText(backgroundColor: backgroundColor))
    }
}

struct CircledText: ViewModifier {
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content.contentShape(Circle())
            .foregroundStyle(Color("QuarterSpanishWhite"))
            .font(.title2)
            .padding(5)
            .background {
                Circle()
                    .fill(backgroundColor)
                    .aspectRatio(contentMode: .fill)
            }
    }
}
