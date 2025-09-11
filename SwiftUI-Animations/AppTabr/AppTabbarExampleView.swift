//
//  AppTabbarExampleView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/11.
//

import SwiftUI


struct AppTabbarExampleView: View {
    @State var progress: CGFloat = 0
    @StateObject var tabbarViewModel = AppTabbarViewModel(
        items: [
        .init(
            icon: Image(.calendar),
              normalColor: .white,
            selectedColor: .red,
            selectedOpacity: 0
        ),
        .init(
            icon: Image(.threads),
            normalColor: .white,
            selectedColor: .red,
            selectedOpacity: 1
        )
    ])
    
    var body: some View {
        VStack(spacing: 100) {
            Slider(value: $progress, in: 0 ... 1)
            AppTabbar(viewModel: tabbarViewModel)
                .padding(.horizontal, 50)
        }
        .padding()
        .onChange(of: progress) { oldValue, newValue in
            print(newValue)
            tabbarViewModel.updateOpacity(newValue, isToRight: false)
        }
    }
}
