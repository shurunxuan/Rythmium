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
    
    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.About
        
        backButton.fontName = "Helvetica Neue UltraLight"
        backButton.name = "backButton"
        backButton.fontSize = 32 * ratio
        backButton.position = CGPointMake(width / 8, height / 8 - backButton.frame.height / 2)
        
        positionLabel.fontName = "Helvetica Neue UltraLight"
        positionLabel.fontSize = 40 * ratio
        positionLabel.position = CGPointMake(width / 2, (height - backButton.position.y - backButton.frame.height) / 2 + 20 * ratio + positionLabel.frame.height)
        
        nameLabel.fontName = "Helvetica Neue UltraLight"
        nameLabel.fontSize = 60 * ratio
        nameLabel.position = CGPointMake(width / 2, (height - backButton.position.y - backButton.frame.height) / 2 - 10 * ratio)
        
        Background = background.copy() as! SKSpriteNode
        addChild(Background)
        addChild(backButton)
        addChild(positionLabel)
        addChild(nameLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            // SKScene跳转
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


