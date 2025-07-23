//
//  CalendarDay.swift
//  Pee-iOS
//
//  Created by Renjun Li on 2025/7/16.
//

import Foundation

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool
}

struct CalendarMonth: Identifiable {
    let id = UUID()
    let date: Date
    let days: [CalendarDay]
}

class CalendarViewModel: ObservableObject {
    @Published var days: [CalendarDay] = []
    @Published var weekdays: [String] = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    @Published var monthList: [CalendarMonth] = []
    let itemSize: CGSize = .init(width: 40, height: 40)
    
    init() {
        monthList = generateMothList(for: 2025)
    }
    
    func generateDays(for moth: Date) -> [CalendarDay] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: moth)!
        let components = calendar.dateComponents([.year, .month], from: moth)
        let firstDay = calendar.date(from: components)!
        var days: [CalendarDay] = []
        let weekdayOffset = calendar.component(.weekday, from: firstDay) - calendar.firstWeekday
        let totalDays = range.count
        
        // 前导空白
        for i in 0 ..< weekdayOffset {
            days.append(
                CalendarDay(
                    date: calendar.date(byAdding: .day, value: -weekdayOffset + i, to: firstDay)!,
                    isCurrentMonth: false,
                    isToday: false
                )
            )
        }
        
        // 当前月天数
        for day in 1...totalDays {
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay)!
            days.append(
                CalendarDay(
                    date: date,
                    isCurrentMonth: true,
                    isToday: calendar.isDateInToday(date)
                )
            )
        }
        // 补齐最大行数
        let maxCounts: Int = 42
        while days.count - maxCounts != 0 {
            let date = calendar.date(byAdding: .day, value: 1, to: days.last!.date)!
            days.append(
                CalendarDay(
                    date: date,
                    isCurrentMonth: false,
                    isToday: false
                )
            )
        }
        return days
    }
    
    
    func generateMothList(for year: Int) -> [CalendarMonth] {
        let calendar = Calendar.current
        var monthList: [CalendarMonth] = []
        for month in 1...12 {
            var component = DateComponents()
            component.year = year
            component.month = month
            guard let date = calendar.date(from: component) else { continue }
            monthList.append(CalendarMonth(date: date, days: generateDays(for: date)))
        }
        return monthList
    }
    
}
    
