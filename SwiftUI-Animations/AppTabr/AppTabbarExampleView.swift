

struct AppTabbarExampleView: View {
    @State var progress: CGFloat = 0
    @StateObject var tabbarViewModel = AppTabbarViewModel(
        items: [
        .init(
            icon: Image(.calendar),
              normalColor: .white,
            selectedColor: .red,
            selectedOpacity: 1
        ),
        .init(
            icon: Image(.threads),
            normalColor: .white,
            selectedColor: .red,
            selectedOpacity: 0
        )
    ])
    var body: some View {
        
        VStack(spacing: 100) {
            Slider(value: $progress, in: 0 ... 1)
                
            AppTabbar(viewModel: tabbarViewModel)
                .padding(.horizontal, 50)
        }
        .padding()
    }
}
