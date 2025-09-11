//
//  AppTabbarExampleView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/11.
//

import SwiftUI

class AppTabbarExampleViewModel: ObservableObject {
     var tabbarViewModel = AppTabbarViewModel(
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
            selectedOpacity: 0
        )
    ])
     var contentViewModel = AppScrollContentViewModel()
    

    init() {
        contentViewModel.didScroll = { [weak self] progress, isToRight in
            guard let self else { return }
            self.tabbarViewModel.updateOpacity(progress, isToRight: isToRight)
        }
        contentViewModel.didEndScroll = { [weak self] index in
            guard let self else { return }
            self.tabbarViewModel.updateSelectedIndex(index)
        }
        tabbarViewModel.didTap = { [weak self] index in
            guard let self else { return }
            self.contentViewModel.scrollTo(index)
        }
    }
}


struct AppTabbarExampleView: View {
    @StateObject var viewModel = AppTabbarExampleViewModel()
   
    var body: some View {
        VStack(spacing: 10) {
            AppScrollContentView(viewModel: viewModel.contentViewModel)
            AppTabbar(viewModel: viewModel.tabbarViewModel)
                .padding(.horizontal, 50)
        }
    }
}


#Preview {
    AppTabbarExampleView()
}
