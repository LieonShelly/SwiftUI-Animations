//
//  AnimatedTextView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/2.
//


import SwiftUI

struct AnimatedMultilineText: View {
    @State private var lines = [
        "Hello, SwiftUI!",
        "This is line two.",
        "Welcome to line three!",
        "Last line here.",
        "This is line two.",
        "Welcome to line three!",
        "Last line here.",
        "This is line two.",
        "Welcome to line three!",
        "Last line here.",
        "This is line two.",
        "Welcome to line three!",
        "Last line here."
    ]
    @State private var visibleLines = 0
    
    var body: some View {
        VStack {
            ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                HStack(spacing: .zero) {
                    ForEach(Array(line.enumerated()), id: \.offset) { charIndex, char in
                        Text(String(char))
                            .offset(x: visibleLines > index ? 0 : 50)
                            .opacity(visibleLines > index ? 1 : 0)
                            .animation(
                                .spring(duration: 0.5)
                                .delay(delayDuration(currentRowIndex: index, charIndex: charIndex)),
                            value: visibleLines
                        )
                    }
                }
                .font(.title)
            }
        }
        .onAppear {
            visibleLines = lines.count
        }
    }
    
    func delayDuration(currentRowIndex: Int, charIndex: Int) -> Double {
        let animationDuration: Double = 0.5
        let preLinesDuration: Double = lines[0 ..< currentRowIndex].reduce(0) { total, line in
            return total + animationDuration + 0.05 * Double(line.count)
        }
        let currentColumnDuration = Double(charIndex) * 0.05
        return preLinesDuration + currentColumnDuration;
    }
}


#Preview {
    AnimatedMultilineText()
}
