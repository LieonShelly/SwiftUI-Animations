//
//  RatingView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/3.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    @Environment(\.isEnabled) var isEnabled
    
    var body: some View {
        HStack {
            ForEach(1..<6, id: \.self) { starNumber in
                Button {
                    if isEnabled {
                        rating = starNumber
                    }
                } label: {
                    Image(systemName: rating >= starNumber ? "star.fill" : "star")
                }
            }
        }
    }
}
