//
//  AppTabbarViewModel.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/11.
//

import Foundation
import Combine

class AppTabbarViewModel: ObservableObject {
    @Published var items: [AppTabbarItem]
    var selectedIndex: Int = 1
    
    init(items: [AppTabbarItem]) {
        self.items = items
    }
    
    
    func didTapTabrItem(_ item: AppTabbarItem) {
        guard !item.isSelected else { return }
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        var newItem = item
        newItem.selectedOpacity = 1.0
        
        let newItems = items.map {
            AppTabbarItem(
                id: $0.id,
                icon: $0.icon,
                normalColor: $0.normalColor,
                selectedColor: $0.selectedColor,
                selectedOpacity: 0
            )}
        items = newItems
        items[index] = newItem
    }
    
    func updateOpacity(_ value: CGFloat, isToRight: Bool) {
        if isToRight {
            let currentIndex = selectedIndex
            let destIndex = currentIndex + 1
            guard destIndex < items.count else { return }
            var cureentItem = items[currentIndex]
            var destItem = items[destIndex]
            
            cureentItem.selectedOpacity = 1 - value
            destItem.selectedOpacity = value
            items[currentIndex] = cureentItem
            items[destIndex] = destItem
            if value >= 1.0 {
                selectedIndex = destIndex
            }
        } else {
            let currentIndex = selectedIndex
            let destIndex = currentIndex - 1
            guard destIndex >= 0 else { return }
            var cureentItem = items[currentIndex]
            var destItem = items[destIndex]
            
            cureentItem.selectedOpacity = 1 - value
            destItem.selectedOpacity = value
            items[currentIndex] = cureentItem
            items[destIndex] = destItem
            if value >= 1.0 {
                selectedIndex = destIndex
            }
        }
    }
}
