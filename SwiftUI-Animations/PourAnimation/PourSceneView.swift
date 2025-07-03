//
//  PourSceneView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/3.
//

import SwiftUI
import SpriteKit

class PouringLiquidScene: SKScene {
    static let shared = PouringLiquidScene()
    
    let dropEmitter = SKEmitterNode(fileNamed: "PourParticle")
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        
        if let dropEmitter, !self.children.contains(dropEmitter) {
            addChild(dropEmitter)
        }
        
        dropEmitter?.position.x = 100
        dropEmitter?.position.y = frame.maxY
    }
}

struct PourSceneView: View {
    var powerScene: SKScene {
        let scene = PouringLiquidScene.shared
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .fill
        return scene
    }
    var body: some View {
        SpriteView(scene: powerScene, options: [.allowsTransparency])
    }
}


#Preview {
    PourSceneView()
}
