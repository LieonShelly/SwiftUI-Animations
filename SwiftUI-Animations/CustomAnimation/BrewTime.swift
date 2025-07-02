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
    var evaluation: [BrewResult]
    
    static var baseTimers: [BrewTime] {
        var timers: [BrewTime] = .init()
        
        timers.append(
            BrewTime(
                timerName: "Black Tea",
                waterAmount: 8,
                teaAmount: 2,
                temperature: 200,
                timerLength: 240,
                evaluation: [BrewResult]()
            )
        )
        var brew = BrewTime(
            timerName: "Green Tea",
            waterAmount: 8,
            teaAmount: 2,
            temperature: 175,
            timerLength: 90,
            evaluation: [BrewResult]()
        )
        brew.evaluation.append(
            BrewResult(
                name: "Green Tea",
                time: 90,
                temperature: 175,
                amountWater: 8,
                amountTea: 2,
                rating: 4
            )
        )
        brew.evaluation.append(
            BrewResult(
                name: "Green Tea",
                time: 90,
                temperature: 175,
                amountWater: 16,
                amountTea: 4,
                rating: 4
            )
        )
        timers.append(brew)
        timers.append(
            BrewTime(
                timerName: "Herbal Tea",
                waterAmount: 8,
                teaAmount: 2,
                temperature: 208,
                timerLength: 300,
                evaluation: [BrewResult]()
            )
        )
        var ooBrew = BrewTime(
            timerName: "Oolong Tea",
            waterAmount: 8,
            teaAmount: 2,
            temperature: 195,
            timerLength: 150,
            evaluation: [BrewResult]()
        )
        ooBrew.evaluation.append(contentsOf: BrewTime.previewObjectEvals.evaluation)
        timers.append(ooBrew)
        timers.append(
            BrewTime(
                timerName: "White Tea",
                waterAmount: 8,
                teaAmount: 2,
                temperature: 175,
                timerLength: 150,
                evaluation: [BrewResult]()
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
            timerLength: 5,
            evaluation: [BrewResult]()
        )
    }
    
    static var previewObjectEvals: BrewTime {
        var brew = BrewTime(
            timerName: "Test",
            waterAmount: 12,
            teaAmount: 4,
            temperature: 200,
            timerLength: 120,
            evaluation: [BrewResult]()
        )
        
        brew.evaluation.append(
            BrewResult(
                name: "Oolong Tea",
                time: 90,
                temperature: 200,
                amountWater: 12,
                amountTea: 4,
                rating: 3
            )
        )
        
        brew.evaluation.append(
            BrewResult(
                name: "Oolong Tea",
                time: 120,
                temperature: 190,
                amountWater: 16,
                amountTea: 6,
                rating: 5
            )
        )
        
        brew.evaluation.append(
            BrewResult(
                name: "Oolong Tea",
                time: 120,
                temperature: 200,
                amountWater: 14,
                amountTea: 6,
                rating: 4
            )
        )
        
        return brew
    }
}



import Foundation

struct BrewResult: Identifiable {
    var id = UUID()
    var name: String
    var time: Int
    var temperature: Int
    var amountWater: Double
    var amountTea: Double
    var rating: Int
}

extension BrewResult {
    static var sampleResult: BrewResult {
        BrewResult(
            name: "Test",
            time: 120,
            temperature: 180,
            amountWater: 8,
            amountTea: 2,
            rating: 2
        )
    }
}
