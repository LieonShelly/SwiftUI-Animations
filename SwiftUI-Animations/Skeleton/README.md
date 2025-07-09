# SkeletonView 文档

## 概述

`SkeletonView` 是一个用于创建骨架屏加载效果的 SwiftUI 组件。它可以在内容加载时显示一个带有动画效果的占位符，提供更好的用户体验。

## 特性

- 🎨 **自定义形状**：支持任何 SwiftUI Shape
- 🌈 **自定义颜色**：可自定义骨架屏颜色
- ✨ **流畅动画**：内置从左到右的扫光动画效果
- 🔄 **自动循环**：动画自动重复播放
- 📱 **SwiftUI 原生**：完全基于 SwiftUI 构建

## 基本用法

### 1. 简单的矩形骨架屏

```swift
SkeletonView(shape: .rect)
    .frame(width: 200, height: 100)
```

### 2. 圆角矩形骨架屏

```swift
SkeletonView(shape: .rect(cornerRadius: 10))
    .frame(width: 200, height: 50)
```

### 3. 圆形骨架屏

```swift
SkeletonView(shape: .circle)
    .frame(width: 60, height: 60)
```

### 4. 自定义颜色

```swift
SkeletonView(shape: .rect, color: .blue.opacity(0.3))
    .frame(width: 200, height: 100)
```

## 实际应用示例

### 列表项骨架屏

```swift
struct ListItemSkeleton: View {
    var body: some View {
        HStack(spacing: 12) {
            // 头像骨架屏
            SkeletonView(shape: .circle)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 8) {
                // 标题骨架屏
                SkeletonView(shape: .rect(cornerRadius: 4))
                    .frame(width: 120, height: 16)
                
                // 副标题骨架屏
                SkeletonView(shape: .rect(cornerRadius: 4))
                    .frame(width: 80, height: 12)
            }
            
            Spacer()
        }
        .padding()
    }
}
```

### 卡片骨架屏

```swift
struct CardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 图片区域骨架屏
            SkeletonView(shape: .rect(cornerRadius: 8))
                .frame(height: 200)
            
            // 标题骨架屏
            SkeletonView(shape: .rect(cornerRadius: 4))
                .frame(height: 20)
            
            // 描述骨架屏
            SkeletonView(shape: .rect(cornerRadius: 4))
                .frame(height: 16)
            
            SkeletonView(shape: .rect(cornerRadius: 4))
                .frame(width: 150, height: 16)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
```

### 条件显示

```swift
struct ContentView: View {
    @State private var isLoading = true
    @State private var data: [String] = []
    
    var body: some View {
        VStack {
            if isLoading {
                // 显示骨架屏
                CardSkeleton()
            } else {
                // 显示实际内容
                ForEach(data, id: \.self) { item in
                    Text(item)
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            data = ["Item 1", "Item 2", "Item 3"]
            isLoading = false
        }
    }
}
```

## 实现原理

### 1. 核心架构

`SkeletonView` 使用泛型设计，接受任何符合 `Shape` 协议的类型：

```swift
struct SkeletonView<S: Shape>: View {
    var shape: S
    var color: Color
    @State private var isAnimating: Bool = false
}
```

### 2. 动画效果实现

骨架屏的扫光效果通过以下步骤实现：

#### 步骤 1：基础形状
```swift
shape.fill(color)  // 填充基础颜色
```

#### 步骤 2：动画层
在 `overlay` 中添加动画层：

```swift
.overlay {
    GeometryReader { geometry in
        let size = geometry.size
        let skeletonWidth = size.width / 2
        let blurRadius = max(skeletonWidth / 2, 30)
        
        Rectangle()
            .fill(.gray)
            .frame(width: skeletonWidth, height: size.height * 2)
            .blur(radius: blurRadius)
            .rotationEffect(.init(degrees: 5))
            .blendMode(.softLight)
            .offset(x: isAnimating ? maxX : minX)
    }
}
```

#### 步骤 3：动画控制
```swift
.onAppear {
    guard !isAnimating else { return }
    withAnimation(animation) {
        isAnimating = true
    }
}
```

### 3. 关键技术点

#### GeometryReader 的使用
- 获取视图的实际尺寸
- 计算动画元素的合适大小和位置

#### 模糊效果 (Blur)
```swift
.blur(radius: blurRadius)
```
- 创建柔和的扫光效果
- 模糊半径根据视图宽度动态计算

#### 混合模式 (Blend Mode)
```swift
.blendMode(.softLight)
```
- 使用 `.softLight` 混合模式
- 让扫光效果与背景色自然融合

#### 裁剪形状
```swift
.clipShape(shape)
```
- 确保动画效果不超出指定的形状边界

#### 组合组
```swift
.compositingGroup()
```
- 将多个效果组合成一个图层
- 提高渲染性能

### 4. 动画参数

```swift
var animation: Animation {
    .easeIn(duration: 0.5).repeatForever(autoreverses: false)
}
```

- **持续时间**：0.5 秒
- **缓动函数**：easeIn（加速进入）
- **重复模式**：无限重复，不自动反转

## 自定义扩展

### 自定义动画

```swift
struct CustomSkeletonView<S: Shape>: View {
    var shape: S
    var color: Color
    var animationDuration: Double = 0.5
    var animationDelay: Double = 0
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        shape.fill(color)
            .overlay {
                // 动画层实现...
            }
    }
    
    var animation: Animation {
        .easeIn(duration: animationDuration)
            .repeatForever(autoreverses: false)
            .delay(animationDelay)
    }
}
```

### 多色骨架屏

```swift
struct MultiColorSkeletonView<S: Shape>: View {
    var shape: S
    var colors: [Color]
    
    @State private var currentColorIndex = 0
    
    var body: some View {
        shape.fill(colors[currentColorIndex])
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false)) {
                    currentColorIndex = (currentColorIndex + 1) % colors.count
                }
            }
    }
}
```

## 性能优化建议

1. **避免过度使用**：只在真正需要的地方使用骨架屏
2. **合理设置尺寸**：避免创建过大的骨架屏视图
3. **使用 compositingGroup**：已经内置，提高渲染性能
4. **及时停止动画**：在视图消失时停止动画以节省资源

## 最佳实践

1. **保持一致性**：在整个应用中使用统一的骨架屏样式
2. **模拟真实布局**：骨架屏应该反映实际内容的布局结构
3. **适当的加载时间**：避免过长的加载时间，通常 2-3 秒为宜
4. **错误处理**：在加载失败时提供适当的错误状态

## 总结

`SkeletonView` 提供了一个简单而强大的骨架屏解决方案，通过其灵活的 API 和流畅的动画效果，可以显著提升应用的用户体验。无论是简单的占位符还是复杂的布局模拟，它都能很好地满足需求。 