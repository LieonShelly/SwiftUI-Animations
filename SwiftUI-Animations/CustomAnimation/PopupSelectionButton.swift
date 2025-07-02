//
//  PopupSelectionButton.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//

import SwiftUI

struct PopupSelectionButton: View {
    @Binding var currentValue: Double?
    var values: [Double]
    @State private var showOptions = false
    @State private var animateOptions = false
    
    var body: some View {
        ZStack {
            Group {
                if showOptions {
                    ForEach(values.indices, id: \.self) { index in
                        Text(values[index], format: .number)
                            .transition(.scale.animation(.easeInOut(duration: 0.25)))
                            .modifier(CircledText(backgroundColor: Color("OliveGreen")))
                            .offset(
                                x: animateOptions ? xOffset(for: index) : 0,
                                y: animateOptions ? yOffset(for: index) : 0
                            )
                            .onTapGesture {
                                currentValue = values[index]
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    animateOptions = false
                                }
                                withAnimation {
                                    showOptions = false
                                }
                            }
                    }
                    
                    Text("\(Image(systemName: "xmark.circle"))")
                        .transition(.opacity.animation(.linear(duration: 0.25)))
                        .modifier(CircledTextToggle(backgroundColor: Color.red))
                }
                if let currentValue {
                    Text(currentValue, format: .number)
                        .modifier(CircledTextToggle(backgroundColor: Color("Bourbon")))
                } else {
                    Text("\(Image(systemName: "exclamationmark"))")
                        .modifier(CircledTextToggle(backgroundColor: Color(.red)))
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.25)) {
                    animateOptions = !showOptions
                }
                
                withAnimation {
                    showOptions.toggle()
                }
            }
        }
    }
    
    private func xOffset(for index: Int) -> Double {
        let distance = 180.0
        let angle = Angle(degrees: Double(90 + 15 * index)).radians
        return distance * sin(angle) - distance
    }
    
    private func yOffset(for index: Int) -> Double {
        let distance = 180.0
        let angle = Angle(degrees: Double(90 + 15 * index)).radians
        return distance * cos(angle) - 45
    }
}

#Preview(body: {
    PopupSelectionButton(
        currentValue: .constant(3),
        values: [1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0]
    )
})
