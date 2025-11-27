//
//  MyCardWalletFlowSegViewV3.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/11/27.
//


import SwiftUI

struct MyCardWalletFlowSegViewV3: View {
    @State var currentTab: Int = 0
    let headerHeight: CGFloat = 300
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                headerView
                bottomView
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(.container, edges: .bottom)
            .navigationTitle("asdfds")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    var headerView: some View {
        Rectangle()
            .fill(Color.random)
            .frame(height: 100)
            .overlay {
                HStack {
                    Text("asdf")
                        .onTapGesture {
                            currentTab = 0
                        }
                    Text("asdf")
                        .onTapGesture {
                            currentTab = 1
                        }
                }
            }
    }
    
    var bottomView: some View {
        PageView(pageCount: 2, currentIndex: $currentTab) {
            contentView
            contentView
        }
    }
    
    var contentView: some View {
        ScrollView {
            LazyVStack {
                Rectangle()
                    .frame(height: 40)
                ForEach(0 ..< 100, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.random)
                        .frame(height: 50)
                }
            }
        }
       
    }
}


