//
//  HomeView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        TabView {
            FeedContentView()
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .overlay(Divider(), alignment: .bottom)
                        .frame(height: viewModel.headerHeight)
                        .overlay(alignment: .bottom) {
                            TabBarView()
                                .frame(height: viewModel.topicsBarHeight)
                        }
                        .ignoresSafeArea(edges: .top)
                }
        }
        .environmentObject(viewModel)
        .task {
            viewModel.fetchData()
        }
    }
}


#Preview {
    HomeView()
}
