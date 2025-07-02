//
//  ReviewView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//



import SwiftUI

struct ReviewView: View {
    var result: BrewResult
    
    var body: some View {
        HStack {
            Text(result.name)
            Text("\(result.temperature)°F")
            Text(result.time, format: .number)
            Spacer()
            StaticRatingView(rating: result.rating)
                .foregroundStyle(.yellow)
        }
    }
}

