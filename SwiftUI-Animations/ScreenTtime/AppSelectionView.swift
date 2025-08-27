//
//  AppSelectionView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/8/27.
//
import SwiftUI

import FamilyControls

struct AppSelectionView: View {
    @State private var selection = FamilyActivitySelection()

    var body: some View {
        VStack {
            FamilyActivityPicker(selection: $selection)
                .frame(height: 300)

            NavigationLink("设置使用时间", destination: TimeLimitView(selection: selection))
                .padding()
                .disabled(selection.applicationTokens.isEmpty)
        }
        .navigationTitle("选择 App")
    }
}
