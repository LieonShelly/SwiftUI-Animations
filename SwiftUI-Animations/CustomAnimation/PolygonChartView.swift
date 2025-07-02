//
//  PolygonChartView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/2.
//

import SwiftUI

struct PolygonChartView: View {
    var values: [Double]
    var graphSize: Double
    var colorArray: [Color]
    var xCenter: Double
    var yCenter: Double
    
    var gradientColors: AngularGradient {
        AngularGradient (
            colors: colorArray + [colorArray.first ?? .black],
            center: .center,
            angle: .degrees(-90)
        )
    }
    
    var body: some View {
        Path { path in
            for index in values.indices {
                let value = values[index]
                let radians = Angle(degrees: 72 * Double(index)).radians
                let x = sin(radians) * graphSize * value
                let y = cos(radians) * -graphSize * value
                
                if index == 0 {
                    path.move(to: .init(x: x, y: y))
                } else {
                    path.addLine(to: .init(x: x, y: y))
                }
            }
            path.closeSubpath()
        }
        .offset(x: xCenter, y: yCenter)
        .fill(gradientColors)
        .opacity(0.5)
    }
}
