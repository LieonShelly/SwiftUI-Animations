//
//  AppTabbarView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/11.
//

import SwiftUI

struct AppTabbarView: View {
    let icon: Image
    let normalColor: Color
    let selectedColor: Color
    let selectedOpacity: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                icon.tint(normalColor)
                    .opacity(1 - selectedOpacity)
                icon.tint(selectedColor)
                    .opacity(selectedOpacity)
            }
        }
    }
}
