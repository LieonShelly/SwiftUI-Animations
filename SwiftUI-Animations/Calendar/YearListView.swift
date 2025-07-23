//
//  YearListView.swift
//  Pee-iOS
//
//  Created by Renjun Li on 2025/7/21.
//

import SwiftUI

struct YearListView: View {
    @State var showMonthList: Bool = false
    @State var scaleAnchor: UnitPoint = .center
    @State var tappedItemSize: CGSize = .zero
    @State var tappedItemFrame: CGRect = .zero
    @State var containerFrame: CGRect = .zero
    @Namespace private var animationNamespace
    @State var selectedId: String = "0"
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                yearView()
            }
            .background(.red)
            .overlay {
                monthView(proxy)
                    .coordinateSpace(.named("animation"))
            }
            .coordinateSpace(.named("animation"))
        }
       
    }
    
   
    func yearView() -> some View {
        LazyVGrid(columns: [
            .init(spacing: 20),
            .init(spacing: 20),
            .init(spacing: 20),
        ],
                  spacing: 20
        ) {
            ForEach(0...100, id: \.self) { index in
                item(id: "\(index)")
            }
        }
    }
    
    func item(id: String) -> some View {
        GeometryReader { itemProxy in
            Rectangle()
                .fill(Color.green)
                .frame(height: 200)
                .onTapGesture { tap in
                    selectedId = id
                    tappedItemFrame = itemProxy.frame(in: .named("animation"))
                    withAnimation(.easeIn(duration: 0.25)) {
                        showMonthList = true
                    }
                }
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    func monthView(_ proxy: GeometryProxy) -> some View {
        let parentFrame = proxy.frame(in: .named("animation"))
        ZStack {
            Color.blue
                .ignoresSafeArea()
                
            Rectangle()
                .fill(Color.yellow)
                .frame(maxWidth: showMonthList ? .infinity : tappedItemFrame.width, maxHeight: showMonthList ? .infinity : tappedItemFrame.height)
                .position(showMonthList ? CGPoint(x: parentFrame.midX, y:  parentFrame.height * 0.5) : CGPoint(x: tappedItemFrame.midX, y: tappedItemFrame.midY))
                .overlay(content: {
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: showMonthList ? .infinity : tappedItemFrame.width, maxHeight: showMonthList ? .infinity : tappedItemFrame.height)
                        .frame(height: 200)
                        .position(showMonthList ? CGPoint(x: parentFrame.midX, y:  parentFrame.height * 0.5) : CGPoint(x: tappedItemFrame.midX, y: tappedItemFrame.midY))
                })
                .onTapGesture { tap in
                    withAnimation {
                        showMonthList = false
                    }
                }
        }.opacity(showMonthList ? 1 : 0)
     
    }
}



#Preview {
    YearListView()
}



struct YearAnimation: ViewModifier {
    var active: Bool
    var anchor: UnitPoint
    var deactiveXScale: CGFloat = .zero
    var deactiveYScale: CGFloat = .zero
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(
                x: active ? 0 : 1,
                y: active ? 0 : 1,
                anchor: anchor
            )
    }
}
