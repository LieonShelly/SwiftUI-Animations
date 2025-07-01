//
//  BrewInfoView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/30.
//

import SwiftUI

struct BrewInfoView: View {
    var brewTimer: BrewTime
    @Binding var amountOfWater: Double
    @State var brewingTemp = 0
    
    var teaToUse: Double {
      let tspPerOz = brewTimer.teaAmount / brewTimer.waterAmount
      return tspPerOz * amountOfWater
    }
    
    struct HeadingText: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(.title.bold())
        }
    }
    
    struct InformationText: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(.title2)
                .padding(.bottom, 15)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Bewing Temperature")
                .modifier(HeadingText())
            
            NumberTransitionView(number: brewingTemp, suffix: "°F")
                .modifier(InformationText())
            
            Text("Water Amount")
              .modifier(HeadingText())
            
            Text("\(amountOfWater.formatted()) ounces")
              .modifier(InformationText())
            
            Slider(value: $amountOfWater, in: 0...24, step: 0.1)
            
            Text("Amount of Tea to Use")
              .modifier(HeadingText())
            Text("\(teaToUse.formatted()) teaspoons")
              .modifier(InformationText())
            
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                brewingTemp = brewTimer.temperature
            }
        }
        .padding()
        .foregroundColor(
            Color("BlackRussian")
        )
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color("QuarterSpanishWhite")
                )
        )
    }
}


#Preview(body: {
    BrewInfoView(brewTimer: BrewTime.previewObject, amountOfWater: .constant(4))
})
