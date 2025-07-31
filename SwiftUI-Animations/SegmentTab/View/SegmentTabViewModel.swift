//
//  SegmentTabViewModel.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import Combine
import SwiftUI

struct SegmentTabData: Equatable {
    let id: UUID = UUID()
    let title: String
}

class SegmentTabViewModel: ObservableObject {
    @Published var titles: [SegmentTabData] = []
    @Published var selectedIndex: Int = 0
    @Published var selectedItem: SegmentTabData?
    
    let tabbarViewH: CGFloat = 48
    
    func update(_ titles: [String]) {
        self.titles = titles.map { SegmentTabData(title: $0) }
        self.selectedItem = self.titles.first
    }
    
    func isSelectedItem(_ item: SegmentTabData) -> Bool {
        selectedItem?.id == item.id
    }
    
    func select(_ item: SegmentTabData) {
        guard let newIndex = titles.firstIndex(where: { $0.id == item.id}) else { return }
        withAnimation(.snappy(duration: 0.25)) {
            self.selectedItem = item
            self.selectedIndex = newIndex
        }
    }
}
