//
//  Stadium.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/26.
//

import SwiftUI

struct Stadium: Shape {
    @Binding var field: CGRect
    @Binding var tribunes: [Int: [Tribune]]
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            
            let widthToHeightRatio = 1.3
            let sectorDiff = width / (CGFloat(Constants.stadiumSectorsCount * 2))
            
            let tribuneSize = CGSize(width: sectorDiff / 3, height: sectorDiff / 4.5)
            
            var smallersSectorFrame = CGRect.zero
            
            (0 ..< Constants.stadiumSectorsCount).forEach { index in
                let sectionWidth = width - sectorDiff * Double(index)
                let sectionHeight = width / widthToHeightRatio - sectorDiff * Double(index)
                let offsetX = (width - sectionWidth) / 2
                let offsetY = (width - sectionHeight) / 2
                
                let sectorRect = CGRect(x: offsetX, y: offsetY, width: sectionWidth, height: sectionHeight)
                
                smallersSectorFrame = sectorRect
                
                let tribuneWidthOffset = (tribuneSize.width / CGFloat(Constants.stadiumSectorsCount * 2)) * Double(index)
                
                path.addPath(
                    Sector(
                        tribunes: $tribunes,
                        index: index,
                        tribuneSize: CGSize(width: tribuneSize.width - tribuneWidthOffset, height: tribuneSize.height),
                        offset: (sectorDiff / 2 - tribuneSize.height) / 2
                    )
                    .path(in: sectorRect)
                )
            }
            
            computeField(in: smallersSectorFrame)
        }
    }
    
    private func computeField(in rect: CGRect) {
        Task {
            field = CGRect(
                x: rect.minX + rect.width * 0.25,
                y: rect.minY + rect.height * 0.25,
                width: rect.width * 0.5,
                height: rect.height * 0.5
            )
        }
    }
}
