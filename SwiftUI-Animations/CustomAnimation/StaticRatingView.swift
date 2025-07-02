//
//  StaticRatingView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//



import SwiftUI

struct StaticRatingView: View {
    var rating: Int
    
    var body: some View {
        ForEach(1..<6, id: \.self) { starNumber in
            Image(systemName: rating >= starNumber ? "star.fill" : "star")
        }

    }
}
