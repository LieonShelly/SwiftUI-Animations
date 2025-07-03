//
//  ContentView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/24.
//
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Sport") {
                    SportTicketView()
                }
                NavigationLink("Brew Timer") {
                    BrewTimer()
                }
            }
            .navigationTitle("Animations")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


#Preview {
    ContentView()
}
