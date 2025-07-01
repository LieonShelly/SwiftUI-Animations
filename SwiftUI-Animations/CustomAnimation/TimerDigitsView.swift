//
//  TimerDigitsView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//

import SwiftUI

struct TimerDigitsView: View {
    var digits: [Int]
    
    var hasMinutes: Bool {
        digits[0] != 0 || digits[1] != 0
    }
    
    var body: some View {
        HStack {
            if hasMinutes {
                if digits[0] != 0 {
                    SlidingNumber(number: Double(digits[0]))
                }
                SlidingNumber(number: Double(digits[1]))
                Text("m")
            }
            
            if hasMinutes || digits[2] != 0 {
                SlidingNumber(number: Double(digits[2]))
            }
            SlidingNumber(number: Double(digits[3]))
            Text("s")
        }
    }
}

#Preview {
    TimerDigitsView(digits: [1, 0, 0, 4])
}
