
import Combine

struct AppTabbarItem: Identifiable {
    var id = UUID().uuidString
    let icon: Image
    let normalColor: Color
    let selectedColor: Color
    var selectedOpacity: CGFloat
    var isSelected: Bool {
        selectedOpacity >= 1.0
    }
}
