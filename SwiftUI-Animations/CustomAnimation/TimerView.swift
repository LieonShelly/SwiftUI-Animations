//
//  TimerView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/30.
//

import SwiftUI

struct TimerView: View {
    @StateObject var timerManager = TimerManager(length: 0)
    @State var brewTimer: BrewTime
    @State var showDone: BrewTime?
    @State var amountOfWater = 0.0
    @State var animateTimer = false
    @State var animatePause = false
    
    let backGroundGradient = LinearGradient(
      colors: [Color("BlackRussian"), Color("DarkOliveGreen"), Color("OliveGreen")],
      startPoint: .init(x: 0.75, y: 0),
      endPoint: .init(x: 0.25, y: 1)
    )
    
    var timerBorderColor: Color {
        switch timerManager.status {
        case .stopped:
            return Color.red
        case .running:
            return Color.blue
        case .done:
            return Color.green
        case .paused:
            return Color.gray
        }
    }
    
    var animationGradient: AngularGradient {
        AngularGradient(colors: [
            Color("BlackRussian"), Color("DarkOliveGreen"), Color("OliveGreen"),
            Color("DarkOliveGreen"), Color("BlackRussian")
        ], center: .center, angle: .degrees(animateTimer ? 360 : 0))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                BrewInfoView(brewTimer: brewTimer, amountOfWater: $amountOfWater)
                CountingTimerView(timerManager: timerManager)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        switch timerManager.status {
                        case .running:
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(animationGradient, lineWidth: 10)
                        case .paused:
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.blue, lineWidth: 10)
                                .opacity(animatePause ? 0.2 : 1.0)
                        default:
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(timerBorderColor, lineWidth: 5)
                        }
                    }
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color("QuarterSpanishWhite")
                            )
                    )
                    .padding([.leading, .trailing], 5)
                    .padding([.top], 15)
                Spacer()
            }
            .padding()
            .background {
                backGroundGradient.ignoresSafeArea()
            }
        }
        .onAppear {
            timerManager.setTime(length: brewTimer.timerLength)
            amountOfWater = brewTimer.waterAmount
        }
        .navigationTitle("\(brewTimer.timerName) Timer")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .font(.largeTitle)
        .onChange(of: timerManager.status) { oldValue, newValue in
            switch newValue {
            case .done:
                showDone = brewTimer
            case .running:
                animatePause = false
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    animateTimer = true
                }
            case .paused:
                animateTimer = false
                withAnimation(.easeIn(duration: 0.5).repeatForever()) {
                    animatePause = true
                }
            default:
                animateTimer = false
                animatePause = false
            }
        }
        .sheet(item: $showDone) { timer in
            
        }
    }
}


#Preview {
    TimerView(brewTimer: BrewTime.previewObject)
}
