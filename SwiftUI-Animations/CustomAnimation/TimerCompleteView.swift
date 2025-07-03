//
//  TimerCompleteView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//

import SwiftUI

struct TimerCompleteView: View {
    @Binding var brewResult: BrewResult?
    @State var rating: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    let backGroundGradient = LinearGradient(
        colors: [Color("BlackRussian"), Color("DarkOliveGreen"), Color("OliveGreen")],
        startPoint: .init(x: 0.75, y: 0),
        endPoint: .init(x: 0.25, y: 1)
    )
    
    var body: some View {
        ZStack {
            backGroundGradient.ignoresSafeArea()
            
            PourAnimationView().ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("Brew Timer Complete")
                    .font(.largeTitle)
                Text("Your \((brewResult?.name ?? "")) tea should be ready. Enjoy.")
                
                Text("Rate Your Brew")
                RatingView(rating: $rating)
                    .tint(.yellow)
                Button("Save Rating") {
                    guard let brew = brewResult else { return }
                    brewResult = BrewResult(
                        name: brew.name,
                        time: brew.time,
                        temperature: brew.temperature,
                        amountWater: brew.amountWater,
                        amountTea: brew.amountTea,
                        rating: rating
                    )
                    presentationMode.wrappedValue.dismiss()
                }
                
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("QuarterSpanishWhite"))
            )
        }
        .foregroundColor(
          Color("BlackRussian")
        )
    }
}


#Preview {
    TimerCompleteView(brewResult: .constant(BrewResult.sampleResult))
}
