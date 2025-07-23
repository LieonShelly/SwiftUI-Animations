//
//  HeatMapViewModel.swift
//  Pee-iOS
//
//  Created by Renjun Li on 2025/7/16.
//

import Foundation

struct HeatDay {
    let id = UUID()
    let date: Date
    let level: Int
}

struct HeatWeek {
    let id = UUID()
    
    var weekDays: [HeatDay] = []
    
    var isEmpty: Bool {
        weekDays.isEmpty
    }
    
    func firstDayInMonthDesc(_ calendar: Calendar) -> String? {
        guard let day = weekDays.first(where: { calendar.component(.day, from: $0.date ) == 1 }) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: day.date)
    }
    
}

struct MonthRange {
    let label: String
    let columnStart: Int
    let columnCount: Int
}

class HeatMapViewModel: ObservableObject {
    @Published var columns: [HeatWeek] = []
    @Published var months: [MonthRange] = []
    @Published var weekdays: [String] = ["Mon", "Wed", "Fri"]
    let calendar: Calendar
    
    init() {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        
        var dateComponent = DateComponents()
        dateComponent.year = 2025
        dateComponent.month = 1
        let startDate = calendar.date(from: dateComponent)!
        
        dateComponent.month = 12
        dateComponent.day = 31
        let endDate = calendar.date(from: dateComponent)!
        
        self.calendar = calendar
        columns = generateHeatMap(from: startDate, to: endDate)
        months = caculateMonthRanges(columns: columns)
    }
    
    func generateHeatMap(from startDate: Date, to endDate: Date) -> [HeatWeek] {
        var date = startDate
        var columns: [HeatWeek] = []
        var currentWeek: HeatWeek = .init()
        while date <= endDate {
            let weekday = calendar.component(.weekday, from: date)
            if weekday == calendar.firstWeekday && !currentWeek.isEmpty {
                columns.append(currentWeek)
                currentWeek = .init()
            }
            currentWeek.weekDays.append(HeatDay(date: date, level: Int.random(in: 0..<4)))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        if !currentWeek.isEmpty {
            columns.append(currentWeek)
        }
        return columns
    }

    func caculateMonthRanges(columns: [HeatWeek] ) -> [MonthRange] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        var result: [MonthRange] = []
        var currentMonth: String? = nil
        var startIndex: Int = 0
        var count: Int = 0
        
        for (index, col) in columns.enumerated() {
            guard let day = col.weekDays.first?.date else { continue }
            let label = formatter.string(from: day)
            if currentMonth == nil {
                currentMonth = label
                startIndex = index
                count = 1
            } else if currentMonth == label {
                count += 1
            } else {
                result.append(
                    MonthRange(label: currentMonth!, columnStart: startIndex, columnCount: count)
                )
                currentMonth = label
                startIndex = index
                count = 1
            }
        }
        if let currentMonth {
            result.append(
                MonthRange(label: currentMonth, columnStart: startIndex, columnCount: count)
            )
        }
        return result
    }
}

