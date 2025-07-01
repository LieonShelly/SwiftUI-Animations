//
//  TimerCompleteView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//




import SwiftUI

struct TimerCompleteView: View {
    var timer: BrewTime
    
    let backGroundGradient = LinearGradient(
      colors: [Color("BlackRussian"), Color("DarkOliveGreen"), Color("OliveGreen")],
      startPoint: .init(x: 0.75, y: 0),
      endPoint: .init(x: 0.25, y: 1)
    )
    
    var body: some View {
        ZStack {
            backGroundGradient.ignoresSafeArea()
            VStack(spacing: 10) {
                Text("Brew Timer Complete")
                    .font(.largeTitle)
                Text("Your \(timer.timerName) tea should be ready. Enjoy.")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("QuarterSpanishWhite"))
            )
        }
        .foregroundColor(
          Color("BlackRussian")
        )
    }
}