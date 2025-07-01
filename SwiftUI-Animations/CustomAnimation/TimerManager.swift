//
//  TimerStatus.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/30.
//

import SwiftUI
import Combine

enum TimerStatus {
    case stopped
    case running
    case paused
    case done
}

class TimerManager: ObservableObject {
    public var timerLength: Int
    @Published var startTime: Date?
    @Published var remainTimeAsString: String
    @Published var remainingTime: Date
    @Published var active = false
    @Published var paused = false
    @Published var digits: [Int]
    @Published var status: TimerStatus = .stopped
    private var originalTime: Int?
    private var activeTimer: Timer?
    private let zeroTime = Calendar.current.date(from: DateComponents(second: 0))
    
    func start() {
        if status == .paused {
            let componentsLeft = Calendar.current.dateComponents([.minute, .second], from: remainingTime)
            let secondsLeft = (componentsLeft.minute ?? 0) * 60 + (componentsLeft.second ?? originalTime ?? 0)
            let startTimeAgo = (originalTime ?? 0) - secondsLeft
            startTime = Calendar.current.date(byAdding: .second, value: -startTimeAgo, to: .now)
        } else {
            startTime = .now
        }
        status = .running
        activeTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
            self.updateTimes()
            if self.remainingTime == self.zeroTime {
                self.stop()
                self.status = .done
            }
        })
        active = true
        paused = false
    }
    
    func stop() {
        status = .stopped
        startTime = nil
        activeTimer?.invalidate()
        activeTimer = nil
        active = false
        paused = false
        if let originalTime {
            timerLength = originalTime
            updateTimes()
        }
    }
    
    
    func togglePause() {
        status = .paused
        startTime = nil
        activeTimer?.invalidate()
        activeTimer = nil
        active = false
        paused = true
    }
    
    
    func setTime(length: Int) {
      originalTime = length
      timerLength = length
      updateTimes()
    }
    
    func updateTimes() {
        withAnimation {
            remainingTime = amountOfTimeLeft()
            remainTimeAsString = timeLeftAsString()
            digits = getTimeDigits()
        }
    }
    
    func timeLeftAsString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.second, .minute]
        
        guard let startTime else {
            let now = Date.now
            let timerLength = Calendar.current.date(byAdding: .second, value: timerLength, to: now)!
            return formatter.string(from: now, to: timerLength) ?? "--"
        }
        
        let endTime = Calendar.current.date(byAdding: .second, value: timerLength, to: startTime)!
        return formatter.string(from: .now, to: endTime) ?? "--"
    }
    
    func getTimeDigits() -> [Int] {
        let timeComponents = Calendar.current.dateComponents([.minute, .second], from: amountOfTimeLeft())
        let minute = timeComponents.minute ?? 0
        let seconds = timeComponents.second  ?? 0
        var digitArray: [Int] = []
        digitArray.append(minute / 10)
        digitArray.append(minute % 10)
        digitArray.append(seconds / 10)
        digitArray.append(seconds % 10)
        
        return digitArray
    }
    
    func amountOfTimeLeft() -> Date {
        guard let startTime else {
            let now = Date.now
            let timerEnd = Calendar.current.date(
              byAdding: .second,
              value: timerLength,
              to: now
            )!
            let length = Calendar.current.dateComponents([.minute, .second], from: now, to: timerEnd)
            let time = DateComponents(minute: length.minute, second: length.second)
            return Calendar.current.date(from: time)!
        }
        
        let endTime = Calendar.current.date(
          byAdding: .second,
          value: timerLength,
          to: startTime
        )!
        
        let length = Calendar.current.dateComponents([.minute, .second], from: .now, to: endTime)
        
        return Calendar.current.date(from: length)!
    }
    
    init(length: Int) {
        self.timerLength = length
        self.remainingTime = .now
        self.remainTimeAsString = ""
        self.digits = []
        self.remainingTime = amountOfTimeLeft()
        self.remainTimeAsString = timeLeftAsString()
        self.digits = getTimeDigits()
    }
}
