//
//  ViewExtensions.swift
//  FloatingTabbar
//
//  Created by Renjun Li on 2025/6/23.
//

import SwiftUI

fileprivate struct HideFloatingTabbBarModifier: ViewModifier {
    var status: Bool
    
    @EnvironmentObject private var helper: FloatingTabViewHelper
    
    func body(content: Content) -> some View {
        content.onChange(of: status) { oldValue, newValue in
            helper.hideTabBar = newValue
        }
    }
}

extension View {
    func hideFloatingTabBar(_ status: Bool) -> some View {
        self.modifier(HideFloatingTabbBarModifier(status: status))
    }
}
