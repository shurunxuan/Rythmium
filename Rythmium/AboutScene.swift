//
//  AboutScene.swift
//  Rythmium
//
//  Created by 舒润萱 on 15/10/9.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import SpriteKit

class AboutScene: SKScene {
    
    var backButton = SKLabelNode(text: "Back")
    
    var positionLabel = SKLabelNode(text: "UI Design / Program")
    var nameLabel = SKLabelNode(text: "SRX")
    
    var Background = SKSpriteNode()
    var touch_particle: [Int : SKEmitterNode] = [:]
    
    override func didMove(to view: SKView) {
        
        Stage = GameStage.about
        
        self.view?.isMultipleTouchEnabled = true
        
        backButton.fontName = "SFUIDisplay-Ultralight"
        backButton.name = "backButton"
        backButton.fontSize = 32 * ratio
        backButton.position = CGPoint(x: width / 8, y: height / 8 - backButton.frame.height / 2)
        
        positionLabel.fontName = "SFUIDisplay-Ultralight"
        positionLabel.fontSize = 40 * ratio
        positionLabel.position = CGPoint(x: width / 2, y: (height - backButton.position.y - backButton.frame.height) / 2 + 20 * ratio + positionLabel.frame.height)
        
        nameLabel.fontName = "SFUIDisplay-Ultralight"
        nameLabel.fontSize = 60 * ratio
        nameLabel.position = CGPoint(x: width / 2, y: (height - backButton.position.y - backButton.frame.height) / 2 - 10 * ratio)
        
        Background = backgroundDark.copy() as! SKSpriteNode
        
        addChild(Background)
        addChild(backButton)
        addChild(positionLabel)
        addChild(nameLabel)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let particle = touch_particle[touch.hash]
            if (particle != nil) {
                particle!.run(SKAction.move(to: location, duration: 0))
                particle!.particleBirthRate = 250 + 300 * touch.force
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let particle = touch_particle[touch.hash]
            if (particle != nil)
            {
                particle!.particleBirthRate = 0
                for child in particle!.children {
                    child.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
                }
                particle!.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
            }
            touch_particle[touch.hash] = nil
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches != nil) {
            touchesEnded(touches, with: nil)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            let particle = Particle.copy() as! SKEmitterNode
            particle.name = "particle" + String(touch.hash)
            particle.position = location
            particle.targetNode = self
            self.addChild(particle)
            touch_particle[touch.hash] = particle

            if node.name != nil {
                switch node.name!{
                case  "backButton":
                    SaveSetting()
                    Scene = StartUpScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                default:
                    break
                }
            }
            
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}


