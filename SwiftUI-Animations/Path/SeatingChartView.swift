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
}

extension CGSize {
    static func +(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
}
