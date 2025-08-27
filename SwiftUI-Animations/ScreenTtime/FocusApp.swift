import SwiftUI
import FamilyControls

@main
struct FocusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
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
