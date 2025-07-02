//
//  TimerControlView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/2.
//

import SwiftUI

struct TimerControlView: View {
    var timerLength: Double
    @Binding var timeLeft: Int?
    @Binding var status: TimerStatus
    @Binding var timerEndTime: Date?
    @Binding var timerFinished: Bool
    
    func startTimer() {
        if status == .paused {
            guard let timeLeft else { return }
            print("Time Left \(timeLeft)")
            timerEndTime = Calendar.current.date(byAdding: .second, value: timeLeft, to: Date())
            status = .running
        } else {
            let endTime = Calendar.current.date(byAdding: .second, value: Int(timerLength), to: Date())
            timerEndTime = endTime
            status = .running
        }
    }
    
    func pauseTimer() {
        guard let endTime = timerEndTime else { return }
        let dateComponents = Calendar.current.dateComponents([.second], from: Date(), to: endTime)
        timeLeft = dateComponents.second ?? Int(timerLength)
        timerEndTime = nil
        status = .paused
    }
    
    func stopTimer() {
        status = .stopped
        timerEndTime = nil
    }
    
    var body: some View {
        HStack {
            Button {
                stopTimer()
            } label: {
                Image(systemName: "stop.fill")
                    .tint(.red)
            }
            .disabled(status != .running && status != .paused)
            Spacer()
                .frame(width: 30)
            Button {
                pauseTimer()
            } label: {
                Image(systemName: "pause.fill")
            }
            .disabled(status != .running)
            Spacer()
                .frame(width: 30)
            Button {
                startTimer()
            } label: {
                Image(systemName: "play.fill")
                    .tint(.green)
            }
            .disabled(status == .running)
        }
    }
}
