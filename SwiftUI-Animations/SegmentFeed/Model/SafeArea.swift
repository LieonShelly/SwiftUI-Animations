//
//  SafeArea.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import SwiftUI
import UIKit

struct SafeArea {
    static var top: CGFloat {
        UIApplication.shared.keyWindowInsets?.top ?? 0
    }

    static var bottom: CGFloat {
        UIApplication.shared.keyWindowInsets?.bottom ?? 0
    }

    static var leading: CGFloat {
        UIApplication.shared.keyWindowInsets?.left ?? 0
    }

    static var trailing: CGFloat {
        UIApplication.shared.keyWindowInsets?.right ?? 0
    }
}

extension UIApplication {
    var keyWindowInsets: UIEdgeInsets? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })?.safeAreaInsets
    }
}
