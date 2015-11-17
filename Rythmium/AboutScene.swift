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
    
    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.About
        
        self.view?.multipleTouchEnabled = true
        
        backButton.fontName = "SFUIDisplay-Ultralight"
        backButton.name = "backButton"
        backButton.fontSize = 32 * ratio
        backButton.position = CGPointMake(width / 8, height / 8 - backButton.frame.height / 2)
        
        positionLabel.fontName = "SFUIDisplay-Ultralight"
        positionLabel.fontSize = 40 * ratio
        positionLabel.position = CGPointMake(width / 2, (height - backButton.position.y - backButton.frame.height) / 2 + 20 * ratio + positionLabel.frame.height)
        
        nameLabel.fontName = "SFUIDisplay-Ultralight"
        nameLabel.fontSize = 60 * ratio
        nameLabel.position = CGPointMake(width / 2, (height - backButton.position.y - backButton.frame.height) / 2 - 10 * ratio)
        
        Background = background.copy() as! SKSpriteNode
        addChild(Background)
        addChild(backButton)
        addChild(positionLabel)
        addChild(nameLabel)
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let particle = touch_particle[touch.hash]
            if (particle != nil)
            { particle!.runAction(SKAction.moveTo(location, duration: 0)) }
            
            print(touch.force)
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let particle = touch_particle[touch.hash]
            if (particle != nil)
            {
                particle!.particleBirthRate = 0
                for child in particle!.children {
                    child.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
                }
                particle!.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
            }
            touch_particle[touch.hash] = nil
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if (touches != nil) {
            touchesEnded(touches!, withEvent: nil)
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            let particle = Particle.copy() as! SKEmitterNode
            particle.name = "particle" + String(touch.hash)
            particle.position = location
            particle.targetNode = self
            self.addChild(particle)
            touch_particle[touch.hash] = particle
            
            print(touch.force)
            
            if node.name != nil {
                switch node.name!{
                case  "backButton":
                    SaveSetting()
                    Scene = StartUpScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                default:
                    break
                }
            }
            
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


