//
//  PopView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/26.
//

import SwiftUI

struct PopTestView: View {
    @State var tapRect: CGRect = .zero
    @State var dotRect: CGRect = .zero
    var space: String = "popUp"
    
    var body: some View {
        HStack {
            PopView()
            PopView()
            PopView()
        }
        .frame(width: 300, height: 50)
       
    }
    
    @ViewBuilder  var popOverView: some View {
        VStack {
            VStack(spacing: .zero) {
                Text("Test")
                    .padding(.horizontal)
                Text("Test")
                    .padding(.horizontal)
            }
            .background(Color.yellow)
            .padding(.bottom, 12)
            .padding(.top, 8 + 12)
            
        }
        .background {
            PopoverBubble()
                .fill(Color.red)
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
        }
      
    }
}


#Preview(body: {
    PopTestView()
})

struct PopView: View {
    @State var showPop: Bool = false
    @State var show: Bool = false
    @State var currentRect: CGRect = .zero
    @State var dotRect: CGRect = .zero
    
    var body: some View {
        ZStack {
            HStack {
                Text("asdf")
                Image(.chevronDown)
                    .rotationEffect(.degrees(showPop ? -180 : 0))
            }
            .currentRect($currentRect, coordinateSpace: .named("name"))
            .background(Color.yellow)
           
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showPop = !showPop
                }
                dotRect = currentRect
            }
            
            VStack {
                Rectangle()
                    .opacity(0)
                    .frame(width: currentRect.width, height: currentRect.height)
                    .disabled(true)
                if showPop {
                    popOverView
                }
            }
            .allowsTightening(true)
            .padding(.top, currentRect.minY)
        }
        .coordinateSpace(.named("name"))
    }
    
    @ViewBuilder  var popOverView: some View {
        VStack {
            VStack(spacing: .zero) {
                Text("Test")
                    .padding(.horizontal)
                Text("Test")
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showPop = !showPop
                        }
                    }
            }
            .background(Color.yellow)
            .padding(.bottom, 12)
            .padding(.top, 8 + 12)
            
        }
        .background {
            PopoverBubble()
                .fill(Color.red)
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
        }
      
    }
    
    @ViewBuilder var backgroundCover: some View {
        if show {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        show = !show
                    }
                    showPop.toggle()
                }
        }
      
    }
}


#Preview {
    PopView()
}


struct PopoverBubble: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let arrowWidth: CGFloat = 18
        let arrowHeight: CGFloat = 8
        let cornerRadius: CGFloat = 8
        let arrowCornerRadius: CGFloat = 2
        let arrowX = rect.maxX - arrowWidth - 8
        let arrowY = rect.minY
        
        let bobbleRect = CGRect(x: rect.minX, y: rect.minY + arrowHeight, width: rect.width, height: rect.height - arrowHeight)
        path.addRoundedRect(in: bobbleRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        let left = CGPoint(x: arrowX, y: arrowY + arrowHeight)
        let tip  = CGPoint(x: arrowX + arrowWidth / 2, y: arrowY)
        let right = CGPoint(x: arrowX + arrowWidth, y: arrowY + arrowHeight)
        
        path.move(to: left)
        path.addLine(to: CGPoint(x: tip.x - arrowCornerRadius, y: tip.y + arrowCornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: tip.x + arrowCornerRadius, y: tip.y + arrowCornerRadius),
            control: tip
        )
        path.addLine(to: right)
        
        
        path.closeSubpath()
        return path
    }
}


public struct FullScreenCoverBackgroundRemovalView: UIViewRepresentable {
    private class BackgroundRemovalView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
    }
    
    public init() {}
    
    public func makeUIView(context: Context) -> UIView {
        return BackgroundRemovalView()
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {}
}



private struct PositionPreferenceKey: PreferenceKey {
    static let defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    func currentRect(_ rect: Binding<CGRect>, coordinateSpace: CoordinateSpace = .global) -> some View {
        overlay {
            GeometryReader { geo in
                Color.clear.preference(key: PositionPreferenceKey.self, value: geo.frame(in: coordinateSpace))
            }
        }
        .onPreferenceChange(PositionPreferenceKey.self) { value in
            rect.wrappedValue = value
        }
    }
    
}
