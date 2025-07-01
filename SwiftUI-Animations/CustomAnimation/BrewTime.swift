//
//  BrewTime.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/30.
//

import Foundation

struct BrewTime: Identifiable {
    var id = UUID()
    var timerName: String
    var waterAmount: Double
    var teaAmount: Double
    var temperature: Int
    var timerLength: Int
    
    static var baseTimers: [BrewTime] {
        var timers: [BrewTime] = []
        timers.append(
            BrewTime(
                timerName: "Black Tea",
                waterAmount: 8,
                teaAmount: 2,
                temperature: 200,
                timerLength: 240
            )
        )
        timers.append(
            BrewTime(
                timerName: "Green Tea",
                waterAmount: 8,
                teaAmount: 2,
                temperature: 175,
                timerLength: 90
            )
        )
        timers.append(
            BrewTime(
                timerName: "Herbal Tea",
                waterAmount: 8,
                teaAmount: 2,
                temperature: 208,
                timerLength: 300
            )
        )
        timers.append(
            BrewTime(
                timerName: "Oolong Tea",
                waterAmount: 8,
                teaAmount: 2,
                temperature: 195,
                timerLength: 150
            )
        )
        timers.append(
            BrewTime(
                timerName: "White Tea",
                waterAmount: 8,
                teaAmount: 2,
                temperature: 175,
                timerLength: 150
            )
        )
        
        return timers
    }
}

extension BrewTime: Hashable {
    static func == (lhs: BrewTime, rhs: BrewTime) -> Bool {
        return lhs.timerName == rhs.timerName && lhs.temperature == rhs.temperature && lhs.timerLength == rhs.timerLength
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(timerName)
        hasher.combine(waterAmount)
        hasher.combine(teaAmount)
        hasher.combine(temperature)
        hasher.combine(timerLength)
    }
}

extension BrewTime {
    static var previewObject: BrewTime {
        return BrewTime(
            timerName: "Test",
            waterAmount: 6,
            teaAmount: 2,
            temperature: 100,
            timerLength: 5
        )
    }
}

