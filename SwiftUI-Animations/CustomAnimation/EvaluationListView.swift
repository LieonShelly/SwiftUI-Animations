//
//  EvaluationListView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//

import SwiftUI

struct EvaluationListView: View {
    var result: [BrewResult]
    @State var showResult = false
    
    var body: some View {
        VStack {
            Text("Ratings")
              .font(.title2)
            ForEach(result) { result in
                ReviewView(result: result)
                    .padding([.top, .bottom], 5)
                    .font(.title3)
                    .contentShape(Rectangle())
                    .font(.footnote)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showResult = true
        }
        .sheet(isPresented: $showResult) {
            TeaRatingsView(ratings: result)
        }
        .padding(10)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(
              Color("QuarterSpanishWhite")
            )
        )
    }
}

#Preview(body: {
    EvaluationListView(result: BrewTime.previewObjectEvals.evaluation)
})
