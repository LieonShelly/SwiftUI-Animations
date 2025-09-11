//
//  AppTabbarItem.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/11.
//

import SwiftUI
import Foundation

struct AppTabbarItem: Identifiable {
    var id = UUID().uuidString
    let icon: Image
    let normalColor: Color
    let selectedColor: Color
    var selectedOpacity: CGFloat
    var isSelected: Bool {
        selectedOpacity >= 1.0
    }
}
