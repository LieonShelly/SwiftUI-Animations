//
//  FocusApp.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/8/27.
//

import SwiftUI
import FamilyControls

@main
struct FocusApp: App {
    var body: some Scene {
        WindowGroup {
            FocusAppContentView()
                .onAppear {
                    requestAuthorization()
                }
        }
    }

    func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            } catch {
                print("授权失败: \(error)")
            }
        }
    }
}
