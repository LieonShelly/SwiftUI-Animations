//
//  AnalogTimerView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/2.
//

import SwiftUI

struct AnalogTimerView: View {
    @State var timerLength = 0.0
    @State var timeLeft: Int?
    @State var status: TimerStatus = .stopped
    @State var timerEndTime: Date?
    @Binding var timerFinished: Bool
    var timer: BrewTime
    
    var body: some View {
        VStack {
            Slider(value: $timerLength, in: 0...600, step: 15)
            
            TimerControlView(
                timerLength: timerLength,
                timeLeft: $timeLeft,
                status: $status,
                timerEndTime: $timerEndTime,
                timerFinished: $timerFinished
            )
            .font(.title)
            
            ZStack {
                Canvas { gContext, size in
                    let timerSize = Int(min(size.width, size.height) * 0.95)
                    let xOffset = (size.width - Double(timerSize)) / 2.0
                    let yOffset = (size.height - Double(timerSize)) / 2.0
                    gContext.translateBy(x: xOffset, y: yOffset)
                    
                    drawBorder(context: gContext, size: timerSize)
                    
                    gContext.translateBy(x: Double(timerSize / 2), y: Double(timerSize / 2))
                    gContext.rotate(by: .degrees(-90))
                    
                    drawMinutes(context: gContext, size: timerSize)
                    drawSeconds(context: gContext, size: timerSize)
                }
                
                TimelineView(.animation(minimumInterval: 0.01, paused: status != .running)) { timeContext in
                    Canvas { gContext, size in
                        let timerSize = Int(min(size.width, size.height))
                        gContext.translateBy(x: size.width / 2, y: size.height / 2)
                        gContext.rotate(by: .degrees(-90))
                        
                        let remainingSeconds = decimalTimeLeftAt(timeContext.date)
                        drawHands(
                            context: gContext,
                            size: timerSize,
                            remainingTime: remainingSeconds
                        )
                    }
                }
            }
            .padding()
        }
        .onAppear {
            timerLength = Double(timer.timerLength)
        }
    }
    
    func drawHands(context: GraphicsContext, size: Int, remainingTime: Double) {
        let length = Double(size / 2)
        
        let secondLeft = remainingTime.truncatingRemainder(dividingBy: 60)
        let secondAngle = secondLeft / 60 * 360
        
        let minuteColor = Color("DarkOliveGreen")
        let secondColor = Color("BlackRussian")
        
        let secondHandPath = createHandPath(
            length: length,
            crossDistance: 0.4,
            middleDistance: 0.6,
            endDistance: 0.7,
            width: 0.007
        )
        
        var secondContext = context
        secondContext.rotate(by: .degrees(secondAngle))
        secondContext.fill(secondHandPath, with: .color(secondColor))
        
        secondContext.stroke(
            secondHandPath,
            with: .color(secondColor),
            lineWidth: 3
        )
        
        let minuteLeft = remainingTime / 60
        let minuteAngle = minuteLeft / 10 * 360
        
        let minutePath = createHandPath(
            length: length,
            crossDistance: 0.3,
            middleDistance: 0.5,
            endDistance: 0.6,
            width: 0.1
        )
        
        var minuteContext = context
        minuteContext.rotate(by: .degrees(minuteAngle))
        minuteContext.fill(
            minutePath,
            with: .color(minuteColor)
        )
        minuteContext.stroke(
            minutePath,
            with: .color(minuteColor),
            lineWidth: 5
        )
    }
    
    func createHandPath(
        length: Double,
        crossDistance: Double,
        middleDistance: Double,
        endDistance: Double,
        width: Double
    ) -> Path {
        let halfWidth = width / 2
        
        var path = Path()
        path.move(to: .zero)
        
        let crossLength = length * crossDistance
        let halfWidthLength = length * halfWidth
        
        path.addCurve(
            to: .init(x: crossLength, y: 0),
            control1: .init(x: crossLength, y: -halfWidthLength),
            control2: .init(x: crossLength, y: -halfWidthLength)
        )
        
        path.addCurve(
            to: .init(x: length * endDistance, y: 0),
            control1: .init(x: middleDistance, y: halfWidthLength),
            control2: .init(x: middleDistance, y: halfWidthLength)
        )
        
        path.addCurve(
            to: .init(x: crossLength, y: 0),
            control1: .init(x: middleDistance, y: -halfWidthLength),
            control2: .init(x: middleDistance, y: -halfWidthLength)
        )
        
        path.addCurve(
            to: .init(x: 0, y: 0),
            control1: .init(x: crossLength, y: halfWidthLength),
            control2: .init(x: crossLength, y: halfWidthLength)
        )
        return path
    }
    
    func drawSeconds(context: GraphicsContext, size: Int) {
        let center = Double(size / 2)
        
        for second in stride(from: 0, through: 60, by: 10) {
            let secondAngle = Double(second) / 60 * 360
            var secondTickPath = Path()
            secondTickPath.move(to: .init(x: center * 0.7, y: 0))
            secondTickPath.addLine(to: .init(x: center * 0.6, y: 0))
            
            var tickContext = context
            tickContext.rotate(by: .degrees(-secondAngle))
            tickContext.stroke(secondTickPath, with: .color(.black))
            
            let secondString = "\(second)"
            let textSize = secondString.calculateTextSizeFor(font: UIFont.preferredFont(forTextStyle: .footnote))
            let textRect = CGRect(x: -textSize.width / 2.0, y: -textSize.height / 2.0, width: .zero, height: .zero)
            let secondAngleRadians = (secondAngle - 90) * Double.pi / 180
            let xShift = sin(-secondAngleRadians) * center * 0.5
            let yShift = cos(-secondAngleRadians) * center * 0.5
            
            var stringContext = context
            stringContext.translateBy(x: xShift, y: yShift)
            stringContext.rotate(by: .degrees(90))
            let resolvedText = stringContext.resolve(
                Text(secondString).font(.footnote)
            )
            stringContext.draw(resolvedText, in: textRect)
        }
    }
    
    func drawMinutes(context: GraphicsContext, size: Int) {
        let center = Double(size / 2)
        
        for minute in 0..<10 {
            let minuteAngle = Double(minute) / 10 * 360
            let minuteTickPath = Path { path in
                path.move(to: .init(x: center, y: 0))
                path.addLine(to: .init(x: center * 0.9, y: 0))
            }
            var tickContext = context
            tickContext.rotate(by: .degrees(-minuteAngle))
            tickContext.stroke(minuteTickPath, with: .color(.black))
            
            let minuteString = "\(minute)"
            let textSize = minuteString.calculateTextSizeFor(font: UIFont.preferredFont(forTextStyle: .title2))
            let textRect = CGRect(x: -textSize.width / 2, y: -textSize.height / 2, width: .zero, height: .zero)
            
            let minuteAngleRadians = Angle(degrees: minuteAngle - 90).radians
            
            let xShift = sin(-minuteAngleRadians) * center * 0.8
            let yShift = cos(-minuteAngleRadians) * center * 0.8
            
            var stringContext = context
            stringContext.translateBy(x: xShift, y: yShift)
            stringContext.rotate(by: .degrees(90))
            
            let resolvedText = stringContext.resolve(
                Text(minuteString).font(.title2)
            )
            stringContext.draw(resolvedText, in: textRect)
        }
    }
    
    func drawBorder(context: GraphicsContext, size: Int) {
        let timerSize = CGSize(width: size, height: size)
        
        let outerPath = Path(ellipseIn: CGRect(origin: .zero, size: timerSize))
        context.stroke(outerPath, with: .color(.black), lineWidth: 3)
    }
    
    func timeLeftString(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        
        return "\(minutes) m \(seconds) s"
    }
    
    
    func timeLeftAt(_ current: Date) -> Int {
        switch status {
        case .stopped:
            return Int(timerLength)
        case .running:
            guard let timerEndTime else {
                return Int(timerLength)
            }
            let dateCompenents = Calendar.current.dateComponents([.second], from: current, to: timerEndTime)
            let remainingTime = dateCompenents.second ?? Int(timerLength)
            if remainingTime <= 0 {
                DispatchQueue.main.async {
                    status = .stopped
                    self.timerEndTime = nil
                    timerFinished = true
                }
            }
            return remainingTime
        case .paused:
            return timeLeft ?? Int(timerLength)
        case .done:
            return 0
        }
    }
    
    
    func decimalTimeLeftAt(_ current: Date) -> Double {
        switch status {
        case .stopped:
            return timerLength
        case .running:
            guard let timerEndTime else {
                return timerLength
            }
            
            let timerDifference = Calendar.current.dateComponents([.second, .nanosecond], from: current, to: timerEndTime)
            let seconds = Double(timerDifference.second ?? Int(timerLength))
            let nanoSeconds = Double(timerDifference.nanosecond ?? 0) / 1e9
            let remainingTime = seconds + nanoSeconds
            if remainingTime <= 0 {
                DispatchQueue.main.async {
                    status = .stopped
                    self.timerEndTime = nil
                    timerFinished = true
                }
            }
            return remainingTime
        case .paused:
            return Double(timeLeft ?? Int(timerLength))
        case .done:
            return 0
        }
    }
    
}


import Foundation
import UIKit

extension String {
    func calculateTextSizeFor(font: UIFont) -> CGSize {
        let string = (self as NSString)
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = string.size(withAttributes: attributes)
        return textSize
    }
}
