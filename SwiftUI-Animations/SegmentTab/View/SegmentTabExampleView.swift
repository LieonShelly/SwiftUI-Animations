//
//  SegmentTabExampleView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import SwiftUI

struct SegmentTabExampleView: View {
    @State var titles: [String] = ["Title", "Title", "Title", "Title", "Title", "Title", "Title"]
    
    var body: some View {
        SegmentTab(
            titles: $titles,
        ) { index in
            ExampleContentView(text: "Page:\(index)")
                .onTapGesture {
                    titles = ["Title0", "Title1", "Title2", "Title3", "Title4", "Title5", "Title6"]
                }
        }
    }
}


struct ExampleContentView: View {
    let text: String
    
    var body: some View {
        ZStack {
            Color.random
            ScrollView {
                ForEach(0 ..< 100, id: \.self) { _ in
                    LazyVStack {
                        Rectangle()
                            .fill(Color.random)
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 20)
                    }
                }
            }
            .contentMargins(.top, 20)
        }
    }
}

#Preview(body: {
    SegmentTabExampleView()
})
