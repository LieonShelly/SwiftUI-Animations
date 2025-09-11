//
//  AppScrollContentView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/11.
//

import SwiftUI


struct AppScrollContentView: View {
    @ObservedObject var viewModel: AppScrollContentViewModel
    @State var scrollPostion: ScrollPosition = .init(x: 0)
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .zero) {
                    Rectangle()
                        .fill(.red)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    
                }
            }
            .scrollPosition($scrollPostion)
            .scrollTargetBehavior(.paging)
            .onScrollPhaseChange { oldPhase, newPhase in
                print("newPhase: \(newPhase))")
            }
            .onScrollGeometryChange(for: CGPoint.self, of: { $0.contentOffset }) { oldValue, newValue in
                print("offset:\(newValue) - progress:\(newValue.x / proxy.size.width)")
            }
        }
       
    }
}


import Combine
import Foundation

class AppScrollContentViewModel: ObservableObject {
    
    
}


#Preview {
    AppScrollContentView(viewModel: .init())
}
