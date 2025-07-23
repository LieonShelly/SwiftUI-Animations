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
        NavigationStack {
            ScrollView {
                yearView()
            }
            .background(.red)
            .navigationTitle("Calendar")
            .navigationDestination(isPresented: $showMonthList) {
                monthView()
                    .navigationTransition(.zoom(sourceID: selectedId, in: animationNamespace))
            }
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
        ZStack {
            Rectangle()
                .fill(Color.random)
                .frame(height: 200)

            Rectangle()
                .fill(Color.random)
                .frame(height: 200)
                .matchedTransitionSource(id: id, in: animationNamespace)
                .onTapGesture { tap in
                    selectedId = id
                    withAnimation(.easeIn(duration: 3)) {
                        showMonthList = true
                    }
                }
        }
        
       
     
    }
    
    @ViewBuilder
    func monthView() -> some View {
        Rectangle()
            .fill(Color.yellow)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(showMonthList ? 1 : 0)
            .overlay(content: {
                Rectangle()
                    .fill(.gray)
                    .frame(height: 200)
                    .matchedGeometryEffect(id: selectedId, in: animationNamespace)
            })
            .onTapGesture { tap in
                withAnimation {
                    showMonthList = false
                }
            }
            .navigationBarBackButtonHidden()
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
