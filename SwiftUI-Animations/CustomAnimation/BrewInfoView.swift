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
    @State var waterTeaRatio: Double?
    
    var teaToUse: Double {
        guard let waterTeaRatio = waterTeaRatio else {
          return brewTimer.waterAmount / brewTimer.teaAmount
        }
        return round(amountOfWater / waterTeaRatio * 100) / 100.0
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
            HStack(alignment: .bottom) {
                Text("\(teaToUse.formatted()) teaspoons")
                  .modifier(InformationText())
                Spacer()
                PopupSelectionButton(
                    currentValue: $waterTeaRatio,
                    values: [1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0])
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

