//
//  RectTribune.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/26.
//

import SwiftUI

struct RectTribune: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            path.addRect(rect)
            path.closeSubpath()
        }
    }
}
