//
//  SwiftUI_AnimationsApp.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/24.
//

import SwiftUI

@main
struct SwiftUI_AnimationsApp: App {
    var body: some Scene {
        WindowGroup {
            CategoryContentView(totalProgress: .constant(0))
        }
    }
}
