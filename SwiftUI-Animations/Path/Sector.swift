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
            tribunses.append(
                makeRectTribuneAt(
                    x: x,
                    y: rect.minY + offset,
                    vertical: false,
                    rotation: 0
                ))
            tribunses.append(
                makeRectTribuneAt(
                    x: x,
                    y: rect.maxY - offset - tribuneSize.height,
                    vertical: false,
                    rotation: -.pi
                ))
        }
        (0..<Int(tribunesVerticalCount)).forEach { index in
            let y = rect.minY + (tribuneSize.width + spacingV) * CGFloat(index) + corner + spacingV
            tribunses.append(
                makeRectTribuneAt(
                x: rect.minX + offset,
                y: y,
                vertical: true,
                rotation: -.pi / 2.0
            ))
            tribunses.append(
                makeRectTribuneAt(
                    x: rect.maxX - offset - tribuneSize.height,
                    y: y,
                    vertical: true,
                    rotation: 3.0 * -.pi / 2.0
                )
            )
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
                let arcTribune = ArcTribune(
                  center: center,
                  radius: radius,
                  innerRadius: innerRadius,
                  startingPoint: startingPoint,
                  startingInnerPoint: startingInnerPoint,
                  startAngle: previousAngle + spacingAngle,
                  endAngle: previousAngle + spacingAngle + angle
                )
                
                let tribune = Tribune(
                    path: arcTribune.path(in: CGRect.zero),
                    seats: computeSeats(for: arcTribune)
                )
                
                previousAngle += spacingAngle + angle
                
                return tribune
            }
            
            tribunes.append(contentsOf: arcTribunes)
        }
    }
    
    private func makeRectTribuneAt(x: CGFloat, y: CGFloat, vertical: Bool, rotation: CGFloat) -> Tribune {
        let rect = CGRect(
            x: x,
            y: y,
            width: vertical ? tribuneSize.height : tribuneSize.width,
            height: vertical ? tribuneSize.width : tribuneSize.height
        )
        return Tribune(
            path: RectTribune().path(in: rect),
            seats: computeSeats(for: rect, at: rotation)
        )
    }
    
    private func computeTribunes(at rect: CGRect, with corner: CGFloat) -> [Tribune] {
        computeRectTribunesPaths(at: rect, corner: corner) +
        computeArcTribunesPaths(at: rect, corner: corner)
    }
    
    private func computeSeats(for tribune: CGRect, at rotation: CGFloat) -> [Seat] {
        var seats: [Seat] = []

        let seatSize = tribuneSize.height * 0.1
        let columnsNumber = Int(tribune.width / seatSize)
        let rowsNumber = Int(tribune.height / seatSize)
        let spacingH = CGFloat(tribune.width - seatSize * CGFloat(columnsNumber)) / CGFloat(columnsNumber)
        let spacingV = CGFloat(tribune.height - seatSize * CGFloat(rowsNumber)) / CGFloat(rowsNumber)

        (0..<columnsNumber).forEach { column in
          (0..<rowsNumber).forEach { row in
            let x = tribune.minX + spacingH / 2.0 + (spacingH + seatSize) * CGFloat(column)
            let y = tribune.minY + spacingV / 2.0 + (spacingV + seatSize) * CGFloat(row)

            let seatRect = CGRect(
              x: x, y: y,
              width: seatSize, height: seatSize
            )

            seats.append(Seat(
              path: SeatShape(rotation: rotation)
                .path(in: seatRect)
              )
            )
          }
        }

        return seats
    }
    
    private func computeSeats(for arcTribune: ArcTribune) -> [Seat] {
      var seats: [Seat] = []

      let seatSize = tribuneSize.height * 0.1
      let rowsNumber = Int(tribuneSize.height / seatSize)
      let spacingV = CGFloat(tribuneSize.height - seatSize * CGFloat(rowsNumber)) / CGFloat(rowsNumber)

      (0..<rowsNumber).forEach { row in
        let radius = arcTribune.radius - CGFloat(row) * (spacingV + seatSize) - spacingV - seatSize / 2.0 // 1
        let arcLength = abs(arcTribune.endAngle - arcTribune.startAngle) * radius // 2
        let arcSeatsNum = Int(arcLength / (seatSize * 1.1)) // 3

        let arcSpacing = (arcLength - seatSize * CGFloat(arcSeatsNum)) / CGFloat(arcSeatsNum) // 1
        let seatAngle = seatSize / radius // 2
        let spacingAngle = arcSpacing / radius // 3
        var previousAngle = arcTribune.startAngle + spacingAngle + seatAngle / 2.0 // 4

        (0..<arcSeatsNum).forEach { _ in
          let seatCenter = CGPoint(
            x: arcTribune.center.x + radius * cos(previousAngle),
            y: arcTribune.center.y + radius * sin(previousAngle)
          )

          let seatRect = CGRect(
            x: seatCenter.x - seatSize / 2,
            y: seatCenter.y - seatSize / 2,
            width: seatSize,
            height: seatSize
          )

          seats.append(
            Seat(
              path: SeatShape(rotation: previousAngle + .pi / 2)
                .path(in: seatRect)
            )
          )

          previousAngle += spacingAngle + seatAngle
        }
      }

      return seats
    }
}


struct SeatShape: Shape {
    let rotation: CGFloat
    
    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            let verticalSpacing = rect.height * 0.1
            let cornerSize = CGSize(width: rect.width / 15, height: rect.height / 15)
            let seatBackHeight = rect.height / 3 - verticalSpacing
            let squabHeight = rect.height / 2 - verticalSpacing
            let skewAngle = .pi / 4.0
            let skewShift = seatBackHeight / tan(skewAngle)
            let seatWidth = rect.width - skewShift
            
            let backRect = CGRect(x: 0, y: verticalSpacing, width: seatWidth, height: seatBackHeight)
            
            let squabRect = CGRect(x: 0, y: rect.height / 2, width: seatWidth, height: squabHeight)
            
            let skew = CGAffineTransform(a: 1, b: 0, c: -cos(skewAngle), d: 1, tx: skewShift + verticalSpacing, ty: 0)
            path.addRoundedRect(in: backRect, cornerSize: cornerSize, transform: skew)
            
            path.addRoundedRect(in: squabRect, cornerSize: cornerSize)
            path.move(to: CGPoint(x: rect.width / 2, y: rect.height / 3))
            
            path.addLine(to: CGPoint(x: rect.width / 2 - skewShift / 2, y: rect.height / 2))
            
            let rotationCenter = CGPoint(x: rect.width / 2, y: rect.height / 2)
            let translationToCenter = CGAffineTransform(translationX: rotationCenter.x, y: rotationCenter.y)
            let iniialTranslation = CGAffineTransform(translationX: rect.minX, y: rect.minY)
            var result = CGAffineTransformRotate(translationToCenter, rotation)
            result = CGAffineTransformTranslate(result, -rotationCenter.x, -rotationCenter.y)
            
            path = path.applying(result.concatenating(iniialTranslation))
        }
    }
}
