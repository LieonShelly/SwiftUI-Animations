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
    @State private var randomAnge: CGFloat = 2
    
    var body: some View {
        let extraOffset = min(CGFloat(index) * 20, CGFloat(visibleCardsCount) * 20)
        let scale = 1 - min(CGFloat(index) * 0.07, CGFloat(visibleCardsCount) * 0.07)
        let rotationDegree: CGFloat = -10
        let rotation = max(min(-offset / viewSize.height, 1), 0) * rotationDegree
        content
            .onGeometryChange(for: CGSize.self, of: {
                $0.size
            }, action: {
                viewSize = $0
            })
            .animation(.smooth(duration: 0.5, extraBounce: 0), value: randomAnge)
            .offset(y: offset)
            .rotationEffect(.degrees(randomAnge * CGFloat(index)), anchor: .center)
            .rotation3DEffect(.degrees(-rotation), axis: (1, 0, 0), anchor: .center, perspective: 0.5)
          
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        /// only allow left side interaction
                        let xOffset = -max(-value.translation.height, 0)
                        if let maxTranslationWidth {
                            let progress = -max(min(-xOffset / maxTranslationWidth, 1), 0) * viewSize.height
                            offset = progress
                        } else {
                            offset = xOffset
                        }
                      
                    })
                    .onEnded({ value in
                        let xVelocity = max(-value.velocity.height /  5, 0)
                        if (-offset + xVelocity) > viewSize.height * 0.65 {
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
            .onTapGesture {
                pushToNextCard()
            }
    }
    
    private func pushToNextCard() {
        withAnimation(.smooth(duration: 0.5, extraBounce: 0).logicallyComplete(after: 0.5), completionCriteria: .logicallyComplete) {
            offset = -viewSize.height
         
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


struct CardStackView: View {
    @State private var cards = ["imgC1", "imgC2", "imgC3"]
    @State private var dragOffset = CGSize.zero
    @State private var isSwiping = false
    
    @State private var isAnimatingOut = false
    @State private var animateTopCardOut = false
    @State private var fadeOut = false
    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element) { index, imageName in
                CardView(imageName: imageName)
                    .scaleEffect(scale(for: index))
                    .offset(offset(for: index))
                    .zIndex(Double(cards.count - index))
                    .opacity(index == 0 ? (fadeOut ? 0 : 1) : 1)
                    .rotationEffect(Angle(degrees: Double(index == 0 ? 2.5 : index == 1 ? -5 : 5)))
                    .animation(.linear(duration: 0.4), value: dragOffset)
                    .animation(.easeInOut(duration: 0.4), value: animateTopCardOut)
                    .animation(.easeOut(duration: 0.4), value: fadeOut)
                    .onTapGesture {
                        swipeTopCard()
                    }
            }
        }
        .frame(width: 400, height: 500)
        .onAppear {
            startAutoPop()
        }
    }
    private func startAutoPop() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            swipeTopCard()
        }
    }
    private func swipeTopCard() {
        isSwiping = true
        isAnimatingOut = true
        animateTopCardOut = true
        fadeOut = true
        let direction: CGFloat = dragOffset.width > 0 ? 1 : -1
        withAnimation(.easeInOut(duration: 1.0)) {
            dragOffset = CGSize(width: direction * 600, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let first = cards.removeFirst()
            cards.append(first)
            dragOffset = .zero
            isSwiping = false
            fadeOut = false
        }
    }
    private func scale(for index: Int) -> CGFloat {
        switch index {
        case 0: return 1.0
        case 1: return 0.95
        case 2: return 0.9
        default: return 0.9
        }
    }
    private func offset(for index: Int) -> CGSize {
        switch index {
        case 0: return .zero
        case 1: return CGSize(width: 0, height: 10)
        case 2: return CGSize(width: 0, height: 20)
        default: return CGSize(width: 0, height: 30)
        }
    }
}
struct CardView: View {
    let imageName: String
    var body: some View {
       Rectangle()
            .fill(Color.random)
            .frame(width: 240, height: 300)
    }
}
#Preview{
    CardStackView()
        .background(.gray)
}
