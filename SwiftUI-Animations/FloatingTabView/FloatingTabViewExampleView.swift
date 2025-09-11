//
//  ContentView.swift
//  FloatingTabbar
//
//  Created by Renjun Li on 2025/6/22.
//

import SwiftUI

enum AppTab: String, CaseIterable, FloatingTabProtocol {
    case memories
    case library
    case albums
    case search

    var sysmbolImage: String {
        switch self {
        case .memories:
            "memories"
        case .library:
            "photo.fill.on.rectangle.fill"
        case .albums:
            "square.stack.fill"
        case .search:
            "magnifyingglass"
        }
    }
}

struct ContentView: View {
    @State private var activeTab: AppTab = .library
    
    var body: some View {
        FloatingTabView(selection: $activeTab) { tab, tabBarHeight in
            switch tab {
            case .memories:
                Text("Memories")
            case .library:
                LibraryView(tabBarHeight: tabBarHeight)
            case .albums:
                Text("albums")
            case .search:
                Text("search")
            }
        }
    }
}

struct LibraryView: View {
    @State private var hideTabBar: Bool = false
    let tabBarHeight: CGFloat
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Button("Hide Tab Bar") {
                    hideTabBar.toggle()
                }
            }
            .padding(.bottom, tabBarHeight + 30)
            .navigationTitle("Library")
        }
        .hideFloatingTabBar(hideTabBar )
    }
}

#Preview {
    ContentView()
}
