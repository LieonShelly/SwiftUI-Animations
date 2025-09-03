//import SwiftUI
//
//struct AnimatedTextCanvasView: View {
//    let text = "Hello SwiftUI"
//    @State private var visibleCount = 0
//    
//    var body: some View {
//        Canvas { context, size in
//            let characters = Array(text)
//            let font = Font.system(size: 40, weight: .bold)
//            
//            var x: CGFloat = 0
//            for (index, char) in characters.enumerated() {
//                let str = String(char)
//                let resolved = context.resolve(Text(str).font(font))
//                let charSize = resolved.measure(in: CGSize(width: CGFloat.infinity, height: CGFloat.infinity))
//                
//                if index < visibleCount {
//                    var t = context.opacity(1)
//                    t.addFilter(.alphaThreshold(min: 0.5, color: .white))
//                    t.translateBy(x: x, y: size.height / 2 - charSize.height / 2)
//                    context.draw(resolved, at: .zero, in: t)
//                }
//                x += charSize.width
//            }
//        }
//        .frame(height: 80)
//        .onAppear {
//            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//                if visibleCount < text.count {
//                    visibleCount += 1
//                } else {
//                    timer.invalidate()
//                }
//            }
//        }
//    }
//}
