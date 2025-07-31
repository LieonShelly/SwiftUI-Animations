//
//  HomeViewModel.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import Foundation
import Observation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published private(set) var topics: [Topic] = []
    @Published private(set) var selectedTopic: Topic?
    private var currentPage: Int = 0
    @Published var selectedTabIndex: Int = 0
    
    var headerHeight: CGFloat {
        SafeArea.top + topicsBarHeight + navigationBarHeight + headerPadding
    }
    let topicsBarHeight: CGFloat = 30
    let navigationBarHeight: CGFloat = 44
    private let headerPadding: CGFloat = 12
    
    
    func select(_ topic: Topic) {
        guard let newIndex = topics.firstIndex(where: { $0.id == topic.id }) else { return }
        if let selectedTopic, let currentIndex = topics.firstIndex(where: { $0.id == selectedTopic.id}) {
            let diff = abs(currentIndex - newIndex)
            withAnimation(diff > 3 ? nil : .snappy) {
                updateSelection(topic, newIndex)
            }
        } else {
            updateSelection(topic, newIndex)
        }
    }
    
    private func updateSelection(_ topic: Topic, _ index: Int) {
        selectedTopic = topic
        selectedTabIndex = index
    }
    
    func isTopicSelected(_ topic: Topic) -> Bool {
        selectedTopic?.id == topic.id
    }
}

extension HomeViewModel {
    func fetchData() {
        topics = [
            .init(id: 0, name: "All", color: "#4A7B9D", posts: [
                .init(id: "0", name: "Name", likes: 234, content: "New climate agreement signed today! 🌍 Thoughts on its impact?", date: .now)
            ]),
            .init(id: 1, name: "Afunny", color: "#4A7B9D", posts: [
                .init(id: "1", name: "Name", likes: 234, content: "New climate agreement signed today! 🌍 Thoughts on its impact?", date: .now)
            ]),
            .init(id: 2, name: "Afunnys", color: "#4A7B9D", posts: [
                .init(id: "2", name: "Name", likes: 234, content: "New climate agreement signed today! 🌍 Thoughts on its impact?", date: .now)
            ]),
            .init(id: 3, name: "gaming", color: "#4A7B9D", posts: [
                .init(id: "3", name: "Name", likes: 234, content: "New climate agreement signed today! 🌍 Thoughts on its impact?", date: .now)
            ]),
            .init(id: 4, name: "aww", color: "#4A7B9D", posts: [
                .init(id: "4", name: "Name", likes: 234, content: "New climate agreement signed today! 🌍 Thoughts on its impact?", date: .now)
            ])
        ]
        updateSelection(topics[0], 0)
    }
}
