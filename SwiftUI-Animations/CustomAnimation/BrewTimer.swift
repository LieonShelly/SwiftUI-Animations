//
//  BrewTimer.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/30.
//

import SwiftUI

struct BrewTimer: View {
    @State var timers = BrewTime.baseTimers
    let backGroundGradient = LinearGradient(
        colors: [Color("BlackRussian"), Color("DarkOliveGreen"), Color("OliveGreen")],
        startPoint: .init(x: 0.75, y: 0),
        endPoint: .init(x: 0.25, y: 1))
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(timers) { timer in
                    NavigationLink {
                        TimerView(brewTimer: timer)
                    } label: {
                        Text(timer.timerName)
                          .font(.title2)
                          .frame(maxWidth: .infinity)
                          .frame(height: 100)
                          .background(
                            RoundedRectangle(cornerRadius: 25.0)
                              .fill(
                                Color("QuarterSpanishWhite")
                              )
                          )
                          .foregroundStyle(
                            Color("BlackRussian")
                          )
                    }
                }.padding(10)
            }
            .background {
                backGroundGradient.ignoresSafeArea()
            }
            .navigationTitle("Brew Timer")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    BrewTimer()
}

