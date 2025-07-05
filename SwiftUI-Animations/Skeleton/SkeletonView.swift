//
//  SkeletonView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/5.
//

import SwiftUI

struct SkeletonView<S: Shape>: View {
    var shape: S
    var color: Color
    @State private var isAnimating: Bool = false
     
    init(shape: S, color: Color = .gray.opacity(0.3)) {
        self.shape = shape
        self.color = color
    }
    
    var body: some View {
        shape.fill(color)
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let skeletonWidth = size.width / 2
                    let blurRadius = max(skeletonWidth / 2, 30)
                    let blurDiameter = blurRadius * 2
                    let minX = -(skeletonWidth + blurRadius)
                    let maxX = size.width + skeletonWidth + blurDiameter
                    Rectangle()
                        .fill(.gray)
                        .frame(width: skeletonWidth, height: size.height * 2)
                        .frame(height: size.height)
                        .blur(radius: blurRadius )
                        .rotationEffect(.init(degrees: 5))
                        .blendMode(.softLight)
                        .offset(x: isAnimating ? maxX : minX)
                }
                .clipShape(shape)
                .compositingGroup()
                .onAppear {
                    guard !isAnimating else { return }
                    withAnimation(animation) {
                        isAnimating = true
                    }
                }
                .onDisappear {
                    isAnimating =  false
                }
                .transaction { tansaction in
                    if tansaction.animation != animation {
                        tansaction.animation = .none
                    }
                }
            }
    }
    
    var animation: Animation {
        .easeIn(duration: 0.5).repeatForever(autoreverses: false)
    }
}


#Preview {
    SkeletonView(shape: .circle)
        .frame(width: 100, height: 100)
}

