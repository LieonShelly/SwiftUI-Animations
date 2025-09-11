//
//  FloatTabConfig.swift
//  FloatingTabbar
//
//  Created by Renjun Li on 2025/6/23.
//

import SwiftUI

public struct FloatTabConfig {
    let activeTint: Color
    let activeBackgroundTint: Color
    let inactiveTint: Color
    let tabAnimation: Animation
    let backgroundColor: Color
    let insetAmount: CGFloat
    let isTranslucent: Bool
    let hPadding: CGFloat
    let bPadding: CGFloat
    
    public init(
        activeTint: Color = .white,
        activeBackgroundTint: Color = .blue,
        inactiveTint: Color = .gray,
        tabAnimation: Animation = .smooth(duration: 0.35, extraBounce: 0),
        backgroundColor: Color = .gray.opacity(0.1),
        insetAmount: CGFloat = 6,
        isTranslucent: Bool = true,
        hPadding: CGFloat = 15,
        bPadding: CGFloat = 5
    ) {
        self.activeTint = activeTint
        self.activeBackgroundTint = activeBackgroundTint
        self.inactiveTint = inactiveTint
        self.tabAnimation = tabAnimation
        self.backgroundColor = backgroundColor
        self.insetAmount = insetAmount
        self.isTranslucent = isTranslucent
        self.hPadding = hPadding
        self.bPadding = bPadding
    }
}

public protocol FloatingTabProtocol {
    var sysmbolImage: String { get }
}
