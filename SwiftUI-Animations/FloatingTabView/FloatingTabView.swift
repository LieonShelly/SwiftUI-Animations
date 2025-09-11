//
//  FloatingTabProtocol.swift
//  FloatingTabbar
//
//  Created by Renjun Li on 2025/6/23.
//

import SwiftUI

public struct FloatingTabView<Content: View, Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: Hashable & RandomAccessCollection {
    @StateObject private var helper: FloatingTabViewHelper = .init()
    @Binding private var selection: Value
    @State private var tabBarSize: CGSize = .zero
    private let config: FloatTabConfig
    private let content: (Value, CGFloat) -> Content
   
    public init(
        config: FloatTabConfig = .init(),
        selection: Binding<Value>,
        @ViewBuilder content: @escaping (Value, CGFloat) -> Content
    ) {
        self._selection = selection
        self.content = content
        self.config = config
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.hashValue) { tab in
                        Tab(value: tab) {
                            content(tab, tabBarSize.height)
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                    }
                }
            } else {
                TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.hashValue) { tab in
                        content(tab, tabBarSize.height)
                            .tag(tab)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }
            FloatingTabBar(config: config, activeTab: $selection)
                .padding(.horizontal, config.hPadding)
                .padding(.bottom, config.bPadding)
                .onGeometryChange(for: CGSize.self, of: { $0.size}, action: { newValue in
                    tabBarSize = newValue
                })
                .offset(y: helper.hideTabBar ? (tabBarSize.height + 100) : 0)
                .animation(config.tabAnimation, value: helper.hideTabBar)
        }
        .environmentObject(helper)
    }
}

fileprivate struct FloatingTabBar<Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: Hashable & RandomAccessCollection {
    var config: FloatTabConfig
    @Binding var activeTab: Value
    @Namespace private var animation
    @State private var toggleSymbolEffect: [Bool] = Array(repeating: false, count: Value.allCases.count)
    
    init(
        config: FloatTabConfig,
        activeTab: Binding<Value>
    ) {
        self.config = config
        self._activeTab = activeTab
    }
    
    var body: some View {
        HStack {
            ForEach(Value.allCases, id: \.hashValue) { tab in
                let isActive = activeTab == tab
                let index = (Value.allCases.firstIndex(of: tab) as? Int) ?? 0
                
                Image(systemName: tab.sysmbolImage)
                    .font(.title)
                    .foregroundStyle(isActive ? config.activeTint : config.inactiveTint)
                    .symbolEffect(.bounce.byLayer.down, value: toggleSymbolEffect[index])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .background {
                        if isActive {
                            Capsule(style: .continuous)
                                .fill( config.activeBackgroundTint.gradient)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .onTapGesture {
                        activeTab = tab
                        toggleSymbolEffect[index].toggle()
                    }
                    .padding(.vertical, config.insetAmount)
            }
        }
        .padding(.horizontal, config.insetAmount)
        .frame(height: 50)
        .background {
            if config.isTranslucent {
                Rectangle().fill(.ultraThinMaterial)
            } else {
                Rectangle().fill(.background)
            }
            Rectangle().fill(config.backgroundColor)
        }
        .clipShape(.capsule(style: .continuous))
        .animation(config.tabAnimation, value: activeTab)
    }
}

class FloatingTabViewHelper: ObservableObject {
    @Published var hideTabBar: Bool = false
}
