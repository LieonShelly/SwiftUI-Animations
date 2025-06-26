//
//  ArcTribune.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/26.
//

import SwiftUI

struct ArcTribune: Shape {
    var center: CGPoint
    var radius: CGFloat
    var innerRadius: CGFloat
    var startingPoint: CGPoint
    var startingInnerPoint: CGPoint
    var startAngle: CGFloat
    var endAngle: CGFloat
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: startingPoint)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .radians(startAngle),
                endAngle: .radians(endAngle),
                clockwise: false
            )
            path.addLine(to: startingInnerPoint)
            path.addArc(
                center: center,
                radius: innerRadius,
                startAngle: .radians(endAngle),
                endAngle: .radians(startAngle),
                clockwise: true
            )
            path.closeSubpath()
        }
    }
}
