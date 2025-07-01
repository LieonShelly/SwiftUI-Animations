//
//  NumberTransitionView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/30.
//

import SwiftUI

struct NumberTransitionView: View, Animatable {
    var number: Int
    var suffix: String
    
    var animatableData: Double {
        get { Double(number) }
        set { number = Int(newValue) }
    }
    
    var body: some View {
        Text(String(number) + suffix)
    }
}
