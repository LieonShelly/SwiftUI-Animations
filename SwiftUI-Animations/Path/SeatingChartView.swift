//
//  SeatingChartView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/26.
//

import SwiftUI

struct SeatingChartView: View {
    @State private var field = CGRect.zero
    @State private var tribunes: [Int: [Tribune]] = [:]
    @State private var percentage: CGFloat = 0.0
    @State private var selectedTribune: Tribune? = nil
    @State private var zoom = 1.25
    @State private var zoomAnchor = UnitPoint.center
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Field().path(in: field)
                    .trim(from: 0, to: percentage)
                    .fill(.green)
                
                Field().path(in: field)
                    .trim(from: 0, to: percentage)
                    .stroke(.white, lineWidth: 2)
                
                Stadium(field: $field, tribunes: $tribunes)
                    .trim(from: 0, to: percentage)
                    .stroke(.white, lineWidth: 2)
                
                ForEach(tribunes.flatMap(\.value), id: \.self) { tribune in
                    tribune.path
                        .trim(from: 0, to: percentage)
                        .stroke(.white, style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .background(
                            tribune.path.trim(from: 0, to: percentage)
                                .fill(selectedTribune == tribune ? .white : .blue)
                        )
                        .onTapGesture(coordinateSpace: .named("stadium")) { tap in
                            let unselected = tribune == selectedTribune
                            let anchor = UnitPoint(x: tap.x / proxy.size.width, y: tap.y / proxy.size.height)
                            LinkedAnimation.easeInOut(for: 0.7) {
                                zoom = unselected ? 1.25 : 12
                            }
                            .link(to: .easeInOut(for: 0.3, action: {
                                selectedTribune = unselected ? nil : tribune
                                zoomAnchor = unselected ? .center : anchor
                            }),
                                  reverse: !unselected)
                        }
                }
            }
            .rotationEffect(.radians(.pi / 2))
            .coordinateSpace(name: "stadium")
            .scaleEffect(zoom, anchor: zoomAnchor)
            .onChange(of: tribunes) { oldValue, newValue in
//                guard newValue.keys.count == Constants.stadiumSectorsCount else { return }
                withAnimation {
                    percentage = 1.0
                }
            }
        }
    }
}

