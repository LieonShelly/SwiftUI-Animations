//
//  Sector.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/26.
//

import SwiftUI

struct Sector: Shape {
    @Binding var tribunes: [Int: [Tribune]]
    var index: Int
    var tribuneSize: CGSize
    var offset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornor = rect.width / 4
        path.addRoundedRect(
            in: rect,
            cornerSize: CGSize(width: cornor, height: cornor),
            style: .continuous
        )
        guard !tribunes.keys.contains(where: { $0 == index }) else {
            return path
        }
        Task {
            tribunes[index] = computeTribunes(at: rect, with: cornor)
        }
        return path
    }
    
    private func computeRectTribunesPaths(at rect: CGRect, corner: CGFloat) -> [Tribune] {
        let segmentWidth = rect.width - corner * 2
        let segmentHeight = rect.height - corner * 2
        let tribunesHorizontalCount = segmentWidth / tribuneSize.width
        let tribunesVerticalCount = segmentHeight / tribuneSize.width
        
        let spacingH = (segmentWidth - tribuneSize.width * tribunesHorizontalCount) / tribunesHorizontalCount
        let spacingV = (segmentHeight - tribuneSize.width * tribunesVerticalCount) / tribunesVerticalCount
        
        var tribunses = [Tribune]()
        (0..<Int(tribunesHorizontalCount)).forEach { index in
            let x = rect.minX + (tribuneSize.width + spacingH) * CGFloat(index) + corner + spacingH
            tribunses.append(makeRectTribuneAt(x: x, y: rect.minY + offset))
            tribunses.append(makeRectTribuneAt(x: x, y: rect.maxY - offset - tribuneSize.height))
        }
        (0..<Int(tribunesVerticalCount)).forEach { index in
            let y = rect.minY + (tribuneSize.width + spacingV) * CGFloat(index) + corner + spacingV
            tribunses.append(makeRectTribuneAt(x: rect.minX + offset, y: y, rotated: true))
            tribunses.append(makeRectTribuneAt(x: rect.maxX - offset - tribuneSize.height, y: y, rotated: true))
        }
        return tribunses
    }
    
    private func computeArcTribunesPaths(at rect: CGRect, corner: CGFloat) -> [Tribune] {
        let radius = corner - offset
        let innerRadius = corner - offset - tribuneSize.height
        
        let arcLength = (.pi / 2) * radius
        let arcTribunesCount = Int(arcLength / (tribuneSize.width * 1.2))
        
        let arcSpacing = (arcLength - tribuneSize.width * CGFloat(arcTribunesCount)) / CGFloat(arcTribunesCount + 1)
        
        let angle = tribuneSize.width / radius
        let spacingAngle = arcSpacing / radius
        
        let arcs: [CGFloat: CGPoint] = [
            .pi: CGPoint(x: rect.minX + corner, y: rect.minY + corner), // 1
            3 * .pi / 2: CGPoint(x: rect.maxX - corner, y: rect.minY + corner), // 2
            2 * .pi: CGPoint(x: rect.maxX - corner, y: rect.maxY - corner), // 3
            5 * .pi / 2: CGPoint(x: rect.minX + corner, y: rect.maxY - corner) // 4
        ]
        
        
        return arcs.reduce(into: [Tribune]()) { tribunes, arc in
            var previousAngle = arc.key
            let center = arc.value
            
            let arcTribunes = (0..<arcTribunesCount).map { _ in
                let startingPoint = CGPoint(
                    x: center.x + radius * cos(previousAngle + spacingAngle),
                    y: center.y + radius * sin(previousAngle + spacingAngle)
                )
                let startingInnerPoint = CGPoint(
                    x: center.x + innerRadius * cos(previousAngle + spacingAngle + angle),
                    y: center.y + innerRadius * sin(previousAngle + spacingAngle + angle)
                )
                
                let tribune = Tribune(
                    path: ArcTribune(
                        center: center,
                        radius: radius,
                        innerRadius: innerRadius,
                        startingPoint: startingPoint,
                        startingInnerPoint: startingInnerPoint,
                        startAngle: previousAngle + spacingAngle,
                        endAngle: previousAngle + spacingAngle + angle
                    )
                    .path(in: CGRect.zero)
                )
                
                previousAngle += spacingAngle + angle
                
                return tribune
            }
            
            tribunes.append(contentsOf: arcTribunes)
        }
    }
    
    private func makeRectTribuneAt(x: CGFloat, y: CGFloat, rotated: Bool = false) -> Tribune {
        Tribune(path: RectTribune()
            .path(in: CGRect(
                x: x,
                y: y,
                width: rotated ? tribuneSize.height : tribuneSize.width,
                height: rotated ? tribuneSize.width : tribuneSize.height
            ))
        )
    }
    
    private func computeTribunes(at rect: CGRect, with corner: CGFloat) -> [Tribune] {
        computeRectTribunesPaths(at: rect, corner: corner) +
        computeArcTribunesPaths(at: rect, corner: corner)
    }
}
