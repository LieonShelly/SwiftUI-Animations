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
                Spacer()
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
            
        }
        .sheet(item: $showDone) { timer in
            
        }
    }
}


#Preview {
    TimerView(brewTimer: BrewTime.previewObject)
}
