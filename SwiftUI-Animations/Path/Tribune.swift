//
//  Tribune.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/26.
//

import SwiftUI

struct Tribune: Hashable, Equatable {
    var path: Path
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(path.description)
    }
}

