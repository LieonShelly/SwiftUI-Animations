//
//  PourAnimationView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/3.
//

import SwiftUI

struct PourAnimationView: View {
    @State var shapeTop = 900.0
    @State var wavePhase = 90.0
    @State var wavePhrase2 = 0.0
    @State var showPour = true
    
    
    let fillColor = Color(red: 0.180, green: 0.533, blue: 0.78)
    let waveColor2 = Color(red: 0.129, green: 0.345, blue: 0.659)
    var waveHeight: Double {
        min(shapeTop / 10.0, 20.0)
    }
    
    var body: some View {
        ZStack {
            if showPour {
                PourSceneView()
            }
            WaveShape(
                waveTop: shapeTop,
                amplitude: waveHeight * 1.2,
                wavelength: 5,
                phase: wavePhrase2
            )
                .fill(waveColor2)
            
            WaveShape(
                waveTop: shapeTop,
                amplitude: waveHeight,
                wavelength: 4,
                phase: wavePhase
            )
            .fill(fillColor)
        }.onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                wavePhase = -90
            }
            
            withAnimation(.easeOut(duration: 0.3).repeatForever()) {
                wavePhrase2 = 270
            }
            
            withAnimation(.linear(duration: 6).delay(1)) {
                shapeTop = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0, execute: {
                showPour = false
            })
        }
    }
}

#Preview(body: {
    PourAnimationView()
})
