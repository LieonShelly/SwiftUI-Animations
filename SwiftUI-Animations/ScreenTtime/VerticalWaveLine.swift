//
//  VerticalWaveLine.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/9.
//

import SwiftUI

struct VerticalWaveLine: View {
    var lineImage: Image
    var lineWidth: CGFloat = 20
    
    var body: some View {
        Rectangle()
            .fill(
                ImagePaint(
                    image: lineImage,
                    sourceRect: CGRect(x: 0, y: 0, width: 1, height: 0.999),
                    scale: 2.0
                )
            )
            
            .frame(width: lineWidth)
            .background(.red)
    }
}


struct VerticalWaveLineExampleView: View {
    var body: some View {
        ScrollView {
            HStack {
                VerticalWaveLine(lineImage: Image(.waveLine), lineWidth: 6)
                
                VStack {
                    ForEach(0 ..< 100, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.random)
                            .frame(height: 60)
                    }
                    
                }
            }
            .padding(.horizontal, 20)
            
        }
        
    }
}


#Preview(body: {
    VerticalWaveLineExampleView()
})
