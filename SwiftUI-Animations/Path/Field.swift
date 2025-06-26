//
//  Field.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/26.
//

import SwiftUI

struct Field: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            print(rect)
            path.addRect(rect)
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.move(to: CGPoint(x: rect.midX, y: rect.midX))
            path.addEllipse(in: CGRect(
                x: rect.midX - rect.width / 8.0,
                y: rect.midY - rect.width / 8.0,
                width: rect.width / 4.0,
                height: rect.width / 4)
            )
        }
    }
}
