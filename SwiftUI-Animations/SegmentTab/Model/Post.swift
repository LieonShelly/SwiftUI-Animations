//
//  Post.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import Foundation

struct Post: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    let likes: Int
    let content: String
    let date: Date
}

