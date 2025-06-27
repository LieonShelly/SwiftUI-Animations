//
//  SeatsSelectionView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/25.
//

import SwiftUI

struct SeatsSelectionView: View {
    var event: Event
    @State private var stadiumZoomed = false
    @State private var selectedTicketsNumber: Int = 0
    @State private var ticketsPurchased: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text(event.team.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .padding([.top, .horizontal])
                    .shadow(radius: 2)
                    .zIndex(1)
                
                HStack {
                    Text(event.date)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image("cart")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: Constants.iconSizeL)
                        .clipped()
                        .foregroundColor(.white)
                }.padding(.horizontal)
                    .shadow(radius: 2)
            }
            
            Spacer()
            
            SeatingChartView(
                zoomed: $stadiumZoomed,
                selectedTicketsNumber: $selectedTicketsNumber
            )
            .aspectRatio(1.0, contentMode: .fit)
            .padding()
            
            Spacer()
            
            Button(
                action: {
                },
                label: {
                    Text("Buy Tickets")
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background {
                            RoundedRectangle(cornerRadius: 36)
                                .fill(.white)
                                .shadow(radius: 2)
                        }
                        .padding(.horizontal)
                }
            )
            .padding(.vertical, Constants.spacingM)
        }
        .background(Constants.orange, ignoresSafeAreaEdges: .all)
    }
}
