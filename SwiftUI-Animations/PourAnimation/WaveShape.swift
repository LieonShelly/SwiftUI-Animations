//
//  WaveShape.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/3.
//

import SwiftUI

struct WaveShape: Shape, Animatable {
    var waveTop: Double = 0.0
    var amplitude = 100.0
    var wavelength = 1.0
    var phase = 0.0
    
    var animatableData: AnimatablePair <
        AnimatablePair<Double, Double>,
        AnimatablePair<Double, Double>
    > {
        get {
            AnimatablePair(
                AnimatablePair(waveTop, amplitude),
                AnimatablePair(wavelength, phase)
            )
        }
        set {
            waveTop = newValue.first.first
            amplitude = newValue.first.second
            wavelength = newValue.second.first
            phase = newValue.second.second
        }
    }
    
    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            for x in 0 ..< Int(rect.width) {
                let angle = Double(x) / rect.width * wavelength * 360 + phase
                let y = sin(Angle(degrees: angle).radians) * amplitude
                
                if x == 0 {
                    path.move(
                        to: .init(
                            x: Double(x),
                            y: waveTop - y
                        )
                    )
                } else {
                    path.addLine(to: .init(
                        x: Double(x),
                        y: waveTop - y
                    ))
                }
            }
            
            path.addLine(to: .init(x: rect.width, y: rect.height))
            path.addLine(to: .init(x: 0, y: rect.height))
            path.closeSubpath()
        }
    }
}


#Preview(body: {
    WaveShape(waveTop: 200)
        .fill(.blue)
})
