//
//  AppScrollContentView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/11.
//

import SwiftUI

struct AppScrollContentView: View {
    @ObservedObject var viewModel: AppScrollContentViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .zero) {
                    Rectangle()
                        .fill(.red)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .id(0)
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .id(1)
                }
            }
            .scrollPosition($viewModel.scrollPostion)
            .scrollTargetBehavior(.paging)
            .onScrollGeometryChange(for: CGPoint.self, of: { $0.contentOffset }) { oldValue, newValue in
                let progress = newValue.x / proxy.size.width
                viewModel.updateScrollProgress(progress)
            }
            .onScrollPhaseChange { oldPhase, newPhase in
                switch newPhase {
                case .idle:
                    viewModel.updateSelectedIndex()
                default: break
                }
            }
        }
       
    }
}




#Preview {
    AppScrollContentView(viewModel: .init())
}
