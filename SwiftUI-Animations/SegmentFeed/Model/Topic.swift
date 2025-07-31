//
//  Topic.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import Foundation

struct Topic: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let color: String
    let posts: [Post]?
}

