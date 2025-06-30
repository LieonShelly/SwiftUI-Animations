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
    @GestureState private var drag: CGSize = .zero
    @GestureState private var manualZoom = 1.0
    @GestureState private var currentRotation: Angle = .radians(0)
    @State private var offset: CGSize = .zero
    @State private var rotation = Angle(radians: .pi / 2)
    @Binding var zoomed: Bool
    @Binding var selectedTicketsNumber: Int
    @State private var selectedSeats: [Seat] = []
    @State private var seatsPercentage: CGFloat = .zero
    
    
    var dragging: some Gesture {
        DragGesture()
            // gestureState 与 drag 进行了绑定
            .updating($drag) { currentState, gestureState, transaction in
                // 将当前拖动的value赋值给gestureState，
                gestureState = currentState.translation
            }
            .onEnded {
                // 手势停止时，保留当前的位置
                offset = offset + $0.translation
            }
    }
    
    var magnification: some Gesture {
        MagnifyGesture()
            .updating($manualZoom) { currentState, gestureState, transaction in
                gestureState = currentState.magnification
            }
            .onEnded {
                zoom *= $0.magnification
                withAnimation {
                    zoomed = zoom > 1.25
                }
            }
    }
    
    var rotationGesture: some Gesture {
        RotateGesture()
            .updating($currentRotation) { currentState, gestureState, transaction in
                gestureState = .radians(currentState.rotation.radians)
            }
            .onEnded {
                rotation += Angle(radians: $0.rotation.radians)
            }
    }
    
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
                }
                
                if let selectedTribune {
                    ForEach(selectedTribune.seats, id: \.self) { seat in
                        ZStack {
                            seat.path
                                .trim(from: 0, to: seatsPercentage)
                                .fill(selectedSeats.contains(seat) ? .green : .blue)
                            
                            seat.path
                                .trim(from: 0, to: seatsPercentage)
                                .stroke(.black, lineWidth: 0.05)
                        }
                    }
                }
            }
            .onTapGesture { tap in
                if let selectedTribune, selectedTribune.path.contains(tap) {
                    findAndSelectSeat(at: tap, in: selectedTribune)
                } else {
                    findAndSelectTribune(at: tap, with: proxy)
                }
            }
            .scaleEffect(zoom * manualZoom, anchor: zoomAnchor)
            .rotationEffect(rotation + currentRotation, anchor: zoomAnchor)
            // 当前位置: 上一次最后的位置 + 当前的偏移
            .offset(offset + drag)
            .simultaneousGesture(dragging)
            .simultaneousGesture(magnification)
            .simultaneousGesture(rotationGesture)
            .coordinateSpace(name: "stadium")
           
            .onChange(of: tribunes) { oldValue, newValue in
//                guard newValue.keys.count == Constants.stadiumSectorsCount else { return }
                withAnimation {
                    percentage = 1.0
                }
            }
        }
    }
    
    private func findAndSelectSeat(at point: CGPoint, in selectedTribune: Tribune) {
        guard let seat = selectedTribune.seats.first(where: { $0.path.boundingRect.contains(point) }) else {
            return
        }
        withAnimation(.easeInOut) {
            if let index = selectedSeats.firstIndex(of: seat) {
                selectedTicketsNumber -= 1
                selectedSeats.remove(at: index)
            } else {
                selectedTicketsNumber += 1
                selectedSeats.append(seat)
            }
        }
    }
    
    private func findAndSelectTribune(at point: CGPoint, with proxy: GeometryProxy) {
        let tribune = tribunes.flatMap(\.value).first(where: { $0.path.boundingRect.contains(point) })
        let unselected = tribune == selectedTribune
        let anchor = UnitPoint(x: point.x / proxy.size.width, y: point.y / proxy.size.height)
        
        seatsPercentage = selectedTribune == nil || !unselected ? 0 : 1
        
        LinkedAnimation.easeInOut(for: 0.7) {
            zoom = unselected ? 1.25 : 25
            seatsPercentage = unselected ? 0 : 1
            zoomed = !unselected
        }
        .link(
            to: .easeInOut(
                for: 0.3,
                action: {
                    selectedTribune = unselected ? nil : tribune
                    zoomAnchor = unselected ? .center : anchor
                    offset = .zero
                }
            ),
            reverse: !unselected
        )
    }
}

extension CGSize {
    static func +(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
}
