//
//  HeatMapView 2.swift
//  Pee-iOS
//
//  Created by Renjun Li on 2025/7/16.
//

import SwiftUI

struct HeatMapView: View {
    enum Constants {
        static let spacing: CGFloat = 4
        static let rectSize: CGSize = .init(width: 12, height: 12)
    }
    @StateObject var viewModel: HeatMapViewModel = .init()
    
    var body: some View {
        HStack(alignment: .bottom, spacing: Constants.spacing) {
            weekDayView
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators:  false) {
                    VStack(spacing: Constants.spacing) {
                        monthView
                        heatMap
                    }
                }
                .onAppear {
                    proxy.scrollTo(viewModel.columns.last!.id)
                }
            }
        }
    }
    
    var monthView: some View {
        HStack(spacing: Constants.spacing) {
            ForEach(viewModel.months, id: \.label) { month in
                HStack {
                    Text(month.label)
                        .font(.caption)
                    Spacer()
                }
                .frame(width: CGFloat(month.columnCount) * Constants.rectSize.width + CGFloat(month.columnCount - 1) * Constants.spacing)
            }
        }
    }
    
    var heatMap: some View {
        HStack(alignment: .top, spacing: Constants.spacing) {
            ForEach(viewModel.columns, id: \.id) { column in
                VStack(spacing: 4) {
                    ForEach(1 ... 7, id: \.self) { row in
                        if let day = column.weekDays.first(where: { viewModel.calendar.component(.weekday, from: $0.date) == row}) {
                            Rectangle()
                                .fill(color(for: day.level))
                                .frame(width: Constants.rectSize.width, height: Constants.rectSize.height)
                        } else {
                            Color.clear
                                .frame(width: Constants.rectSize.width, height: Constants.rectSize.height)
                        }
                    }
                    .id(column.id)
                }
            }
        }
    }
    
   @ViewBuilder var weekDayView: some View {
       let height = Constants.rectSize.height * 7 + Constants.spacing * 6
        VStack(spacing: .zero) {
            GeometryReader {proxy in
                Text(viewModel.weekdays[0])
                    .font(.caption)
                    .position(x: proxy.size.width * 0.5, y: Constants.rectSize.height * 1.5 + Constants.spacing)
                
                Text(viewModel.weekdays[1])
                    .font(.caption)
                    .position(x: proxy.size.width * 0.5, y: Constants.rectSize.height * 3.5 + Constants.spacing * 3)
                
                Text(viewModel.weekdays[2])
                    .font(.caption)
                    .position(x: proxy.size.width * 0.5, y: Constants.rectSize.height * 5.5 + Constants.spacing * 5)
            }
            .frame(width: 40, height: height)
        }
        .frame(width: 40, height: height)
    }
    
    func color(for level: Int) -> Color {
        switch level {
        case 1: return .green.opacity(0.3)
        case 2: return .green.opacity(0.5)
        case 3: return .green.opacity(0.7)
        case 4: return .green
        default: return .gray.opacity(0.2)
        }
    }
}

#Preview {
    HeatMapView()
        .padding()
}
