//
//  LoopingStack.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/23.
//

import SwiftUI

struct LoopingStack<Content: View>: View {
    var maxTranslationWidth: CGFloat? = nil
    @ViewBuilder var content: Content
    let visibleCardsCount: Int = 3
    @State private var rotation: Int = 0
    
    var body: some View {
        Group(subviews: content) { collection in
            let collection = collection.rotateFromLeft(by: rotation)
            let count = collection.count
            ZStack {
                ForEach(collection) { view in
                    let index = collection.index(view)
                    let zIndex = Double(count - index)
                 
                    LoopingStackCardView(
                        index: index,
                        count: collection.count,
                        visibleCardsCount: visibleCardsCount,
                        rotation: $rotation,
                        maxTranslationWidth: maxTranslationWidth
                    ) {
                        view
                    }
                        .zIndex(zIndex)
                }
            }
        }
    }
}

fileprivate struct LoopingStackCardView<Content: View>: View {
    var index: Int
    let count: Int
    let visibleCardsCount: Int
    @Binding var rotation: Int
    var maxTranslationWidth: CGFloat? = nil
    @ViewBuilder var content: Content
    @State private var offset: CGFloat = .zero
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        let extraOffset = min(CGFloat(index) * 20, CGFloat(visibleCardsCount) * 20)
        let scale = 1 - min(CGFloat(index) * 0.07, CGFloat(visibleCardsCount) * 0.07)
        let rotationDegree: CGFloat = -40
        let rotation = max(min(-offset / viewSize.width, 1), 0) * rotationDegree
        content
            .onGeometryChange(for: CGSize.self, of: {
                $0.size
            }, action: {
                viewSize = $0
            })
            .offset(x: extraOffset)
            .scaleEffect(scale, anchor: .trailing)
            .animation(.smooth(duration: 0.25, extraBounce: 0), value: index)
            .offset(x: offset)
            .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0), anchor: .center, perspective: 0.5)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        /// only allow left side interaction
                        let xOffset = -max(-value.translation.width, 0)
                        if let maxTranslationWidth {
                            let progress = -max(min(-xOffset / maxTranslationWidth, 1), 0) * viewSize.width
                            offset = progress
                        } else {
                            offset = xOffset
                        }
                      
                    })
                    .onEnded({ value in
                        let xVelocity = max(-value.velocity.width /  5, 0)
                        if (-offset + xVelocity) > viewSize.width * 0.65 {
                            print("Push to next card")
                            pushToNextCard()
                        } else {
                            withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                                offset = .zero
                            }
                        }
                    }),
                isEnabled: index == 0 && count > 1
            )
    }
    
    private func pushToNextCard() {
        withAnimation(.smooth(duration: 0.25, extraBounce: 0).logicallyComplete(after: 0.15), completionCriteria: .logicallyComplete) {
            offset = -viewSize.width
        } completion: {
            rotation += 1
            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                offset = .zero
            }
        }

    }
}

extension SubviewsCollection {
   
    func rotateFromLeft(by: Int) -> [SubviewsCollection.Element] {
        let moveIndex = by % count
        let rotatedElements = Array(self[moveIndex...]) + Array(self[0 ..< moveIndex])
        return rotatedElements
    }
}

extension [SubviewsCollection.Element] {
    func index(_ item: SubviewsCollection.Element) -> Int {
        firstIndex(where: { $0.id == item.id }) ?? 0
    }
}

#Preview {
    LoopingStackExampleView()
}
