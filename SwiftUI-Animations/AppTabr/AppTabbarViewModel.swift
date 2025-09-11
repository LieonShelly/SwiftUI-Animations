
import Combine

class AppTabbarViewModel: ObservableObject {
    @Published var items: [AppTabbarItem]
    
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
}