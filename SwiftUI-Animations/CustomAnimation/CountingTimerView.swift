//
//  CountingTimerView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//

import SwiftUI

struct CountingTimerView: View {
    @ObservedObject var timerManager: TimerManager
    
    var body: some View {
        VStack(spacing: 15) {
            TimerDigitsView(digits: timerManager.digits)
                .frame(height: 100)
            HStack {
                Button {
                    timerManager.stop()
                } label: {
                    Image(systemName: "stop.fill")
                        .tint(.red)
                }
                .disabled(!timerManager.active && !timerManager.paused)
                Spacer()
                    .frame(width: 30)
                Button {
                    timerManager.togglePause()
                } label: {
                    Image(systemName: "pause.fill")
                }
                .disabled(timerManager.paused || !timerManager.active)
                Spacer()
                    .frame(width: 30)
                Button {
                    timerManager.start()
                } label: {
                    Image(systemName: "play.fill")
                        .tint(.green)
                }
                .disabled(timerManager.active)
            }
        }
        .padding(20)
    }
}

#Preview {
    CountingTimerView(timerManager: TimerManager(length: 5))
}



extension Int {
    func between(_ low: Int, and high: Int) -> Int {
        let range = high - low
        var value = self
        while value < low {
            value += range
        }
        while value >= high {
            value -= range
        }
        return value
    }
}
