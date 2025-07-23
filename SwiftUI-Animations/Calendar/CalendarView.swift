//
//  HeatMapView.swift
//  Pee-iOS
//
//  Created by Renjun Li on 2025/7/15.
//

import SwiftUI

struct CalendarView: View {
    enum Constants {
        static let itemSize: CGSize = .init(width: 40, height: 40)
        static let spacing: CGFloat = 10
        static let maxRowCount: CGFloat = 7
        static let cornorRadius: CGFloat = 4
    }
    @StateObject var viewModel: CalendarViewModel = .init()
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: Constants.spacing) {
               weekDay()
                    .frame(width: proxy.size.width, height: Constants.itemSize.height)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: .zero) {
                        ForEach(viewModel.monthList, id: \.id) { month in
                            moth(days: month.days)
                                .frame(width: proxy.size.width)
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
            }
            .frame(height: Constants.maxRowCount * Constants.itemSize.height + (Constants.maxRowCount) * Constants.spacing)
        }
        
    }
    
    @ViewBuilder
    func moth(days: [CalendarDay]) -> some View {
        let itemWidth: CGFloat = Constants.itemSize.width
        let columns = Array(repeating: GridItem(.fixed(itemWidth), spacing: Constants.spacing), count: 7)
        LazyVGrid(
            columns: columns,
            spacing: Constants.spacing,
            content: {
                ForEach(days) { day in
                    Text("\(Calendar.current.component(.day, from: day.date))")
                        .frame(width: itemWidth, height: itemWidth)
                        .foregroundColor(day.isCurrentMonth ? .primary : .gray)
                        .background(day.isToday ? Color.blue : Color.red)
                }
            })
      
    }
    
   @ViewBuilder func weekDay() -> some View {
       let itemW: CGFloat = Constants.itemSize.width
        let spacing = Constants.spacing
        HStack(spacing: spacing) {
            ForEach(viewModel.weekdays, id: \.self) { day in
                Text(day)
                   
                    .frame(width: itemW, height: itemW)
                    .background(.blue)
            }
        }
        .frame(height: Constants.itemSize.height)
        .background(.yellow)
    }
}

#Preview(body: {
    HStack {
        CalendarView().frame(height: 360)
    }
    .padding()
})


extension Color {
   static var random: Color {
        Color(red: Double.random(in: 0 ... 255) / 255.0, green: Double.random(in: 0 ... 255) / 255.0, blue: Double.random(in: 0 ... 255) / 255.0)
    }
}
