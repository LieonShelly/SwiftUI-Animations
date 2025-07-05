//
//  SkeletonSampleView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/5.
//

import SwiftUI

struct SkeletonSampleView: View {
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    if isLoading {
                        SkeletonView(shape: .rect)
                    } else {
                        Text("Success")
                            .foregroundStyle(.accent)
                            .font(.title)
                    }
                }
                .frame(height: 220)
                .clipped()
            
            if isLoading {
                SkeletonView(shape: .rect(cornerRadius: 5))
                    .frame(height: 20)
            } else {
                Text("Success")
                    .foregroundStyle(.accent)
                    .font(.title)
            }
            
            Group {
                if isLoading {
                    SkeletonView(shape: .rect(cornerRadius: 5))
                        .frame(height: 15)
                    
                    SkeletonView(shape: .rect(cornerRadius: 5))
                        .frame(height: 15)
                } else {
                    Text("Success")
                        .foregroundStyle(.accent)
                        .font(.title)
                }
            }
        }
        .padding(.horizontal, 20)
        .task {
            try? await Task.sleep(for: .seconds(5))
            isLoading = false
        }
    }
}

#Preview {
    SkeletonSampleView().colorScheme(.dark)
}
