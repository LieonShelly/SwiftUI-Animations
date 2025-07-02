//
//  AnimatedRadarChart.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//

import SwiftUI

struct AnimatedRadarChart: View, Animatable {
    var time: Double
    var temperature: Double
    var amountWater: Double
    var amountTea: Double
    var rating: Double
    
    var animatableData: AnimatablePair<
        AnimatablePair<Double, Double>,
        AnimatablePair<
            AnimatablePair<Double, Double>,
            Double
        >
    > {
        get {
            AnimatablePair(
                AnimatablePair(time, temperature),
                AnimatablePair(
                    AnimatablePair(amountWater, amountTea),
                    rating
                )
            )
        }
        set {
            time = newValue.first.first
            temperature = newValue.first.second
            amountWater = newValue.second.first.first
            amountTea = newValue.second.first.second
            rating = newValue.second.second
        }
    }
    
    var values: [Double] {
        [
            time / 600.0,
            temperature / 212.0,
            amountWater / 16.0,
            amountTea / 16.0,
            rating / 5.0
        ]
    }
    
    let lineColors: [Color] = [.black, .red, .blue, .green, .yellow]
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let grapSize = min(proxy.size.width, proxy.size.height) / 2.0
                let xCenter = proxy.size.width / 2.0
                let yCenter = proxy.size.height / 2.0
                
                let chartFraction = Array(stride(from: 0.2, to: 1.0, by: 0.2))
                
                ForEach(chartFraction, id: \.self) { val in
                    Path { path in
                        path.addArc(
                            center: .zero,
                            radius: grapSize * val,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360),
                            clockwise: true
                        )
                    }
                    .stroke(.gray, lineWidth: 1)
                    .offset(x: xCenter, y: yCenter)
                }
                
                ForEach(0..<5, id: \.self) { index in
                    Path { path in
                        path.move(to: .zero)
                        path.addLine(to: .init(x: 0, y: -grapSize))
                    }
                    .stroke(.gray, lineWidth: 1)
                    .offset(x: xCenter, y: yCenter)
                    .rotationEffect(.degrees(72 * Double(index)))
                    
                    Path { path in
                        path.move(to: .zero)
                        path.addLine(to: .init(x: 0, y: -grapSize * values[index]))
                    }
                    .stroke(lineColors[index], lineWidth: 2)
                    .offset(x: xCenter, y: yCenter)
                    .rotationEffect(.degrees(72 * Double(index)))
                }
                
                PolygonChartView(values: values, graphSize: grapSize, colorArray: lineColors, xCenter: xCenter, yCenter: yCenter)
            }
        }
    }
}

#Preview {
    AnimatedRadarChart(
      time: Double(BrewResult.sampleResult.time),
      temperature: Double(BrewResult.sampleResult.temperature),
      amountWater: BrewResult.sampleResult.amountWater,
      amountTea: BrewResult.sampleResult.amountTea,
      rating: Double(BrewResult.sampleResult.rating)
    )
}

