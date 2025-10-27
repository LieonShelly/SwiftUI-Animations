//
//  SwiftUI_AnimationsApp.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/24.
//

import SwiftUI

@main
struct SwiftUI_AnimationsApp: App {
    var body: some Scene {
        WindowGroup {
            SportTicketView()
        }
    }
}



func dumpViewTree(_ view: Any, _ indent: String = "") {
    let mirror = Mirror(reflecting: view)
    print("\(indent)\(type(of: view))")
    for child in mirror.children {
        if let label = child.label {
            print("\(indent)├─ \(label): \(type(of: child.value))")
        } else {
            print("\(indent)├─ \(type(of: child.value))")
        }
        dumpViewTree(child.value, indent + "| ")
    }
}

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}
