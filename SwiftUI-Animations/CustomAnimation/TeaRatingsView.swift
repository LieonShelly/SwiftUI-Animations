//
//  TeaRatingsView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/1.
//

import SwiftUI

struct TeaRatingsView: View {
    var ratings: [BrewResult]
    @State var selectedRating: Int = 0
    
    let backGroundGradient = LinearGradient(
        colors: [Color("BlackRussian"), Color("DarkOliveGreen"), Color("OliveGreen")],
        startPoint: .init(x: 0.75, y: 0),
        endPoint: .init(x: 0.25, y: 1)
    )
    
    var body: some View {
        ZStack {
            backGroundGradient.ignoresSafeArea()
            
            VStack {
                VStack {
                    TabView(selection: $selectedRating) {
                        ForEach(ratings.indices, id: \.self) { ratingIndex in
                            VStack {
                                Text(ratings[ratingIndex].name)
                                Text("\(ratings[ratingIndex].temperature) °F")
                                Text(ratings[ratingIndex].time, format: .number) + Text(" s")
                                Text("\(ratings[ratingIndex].amountTea.formatted()) tsp.") +
                                Text("/ \(ratings[ratingIndex].amountWater.formatted()) oz.")
                                StaticRatingView(rating: ratings[ratingIndex].rating)
                                    .foregroundColor(.yellow)
                            }
                            .tabItem {
                                Text(ratings[ratingIndex].name)
                            }
                            .tag(ratingIndex)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    HStack {
                        ForEach(ratings.indices, id: \.self) { index in
                            Rectangle()
                                .fill(selectedRating == index ? Color("OliveGreen") : Color("DarkOliveGreen"))
                                .frame(width: 25, height: 10)
                                .onTapGesture {
                                    selectedRating = index
                                }
                        }
                    }
                }
                    .frame(height: 160)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color("QuarterSpanishWhite")
                            )
                    )
                
                Spacer()
                
                AnimatedRadarChart(
                    time: Double(ratings[selectedRating].time),
                    temperature: Double(ratings[selectedRating].temperature),
                    amountWater: Double(ratings[selectedRating].amountWater),
                    amountTea: Double(ratings[selectedRating].amountTea),
                    rating: Double(ratings[selectedRating].rating)
                )
                .aspectRatio(contentMode: .fit)
                .animation(.linear, value: selectedRating)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("QuarterSpanishWhite"))
                )
            }
            .font(.body)
            .padding()
        }
    }
}

#Preview {
    TeaRatingsView(ratings: BrewTime.previewObjectEvals.evaluation)
}

