//
//  SlidingNumber.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//

import SwiftUI

struct SlidingNumber: View, Animatable {
   var number: Double
    
    var animatableData: Double {
        get { number }
        set { number = newValue }
    }
    
    var body: some View {
        let digitArray = [number - 1, number, number + 1].map { Int($0).between(0, and: 10) }
        let shift = 1 - number.truncatingRemainder(dividingBy: 1)
        VStack {
            Text(String(digitArray[0]))
            Text(String(digitArray[1]))
            Text(String(digitArray[2]))
        }
        .font(.largeTitle)
        .fontWeight(.heavy)
        .frame(width: 30, height: 40)
        .offset(y: 40 * shift)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    SlidingNumber(number: 0)
}
