# SwiftUI-Animations

- matchedGeometryEffect 方法的作用是什么
    - matchedGeometryEffect 是 SwiftUI 中非常强大和直观的 “共享元素动画” 工具，它允许你在 两个视图之间创建平滑的动画过渡。
    - 跨视图动画
    - 实现“一个元素变成另一个元素”的视觉错觉
    - 让视图的位置、大小、圆角等属性平滑过渡
    - 多用于弹窗、卡片详情、Tab 切换等场景
    - 两个视图不能同时显示：否则 SwiftUI 会警告有冲突（除非使用 .isSource）
    - 在动画过程中，SwiftUI 只保留一个视图作为“源”，另一个会自动消失/出现
    - id 和 namespace 必须完全一致
    ```Swift
    struct MatchedGeometryExample: View {
        @Namespace private var ns
        @State private var expanded = false

        var body: some View {
            VStack {
                if !expanded {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width: 100, height: 100)
                        .matchedGeometryEffect(id: "box", in: ns)
                }

                Spacer()

                if expanded {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.blue)
                        .frame(width: 300, height: 400)
                        .matchedGeometryEffect(id: "box", in: ns)
                }
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    expanded.toggle()
                }
            }
        }
    }

    ```


