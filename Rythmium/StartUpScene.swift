//
//  GameScene.swift
//  UntitledMusicGame
//
//  Created by 舒润萱 on 15/7/7.
//  Copyright (c) 2015年 舒润萱. All rights reserved.
//

import SpriteKit

class StartUpScene: SKScene {
    
    var titleLabel = SKLabelNode(text: "Rythmium")
    var startGameButton = SKLabelNode(text: "START GAME")
    var settingButton = SKLabelNode(text: "SETTINGS")
    var aboutButton = SKSpriteNode(imageNamed: "about")
    
    var Background = SKSpriteNode()
    
    var touch_particle: [Int : SKEmitterNode] = [:]
    
    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.StartUp
        
        titleLabel.fontName = "SFUIDisplay-Ultralight"
        startGameButton.fontName = "SFUIDisplay-Ultralight"
        settingButton.fontName = "SFUIDisplay-Ultralight"
        
        titleLabel.fontSize = 80 * ratio
        startGameButton.fontSize = 40 * ratio
        settingButton.fontSize = 40 * ratio
        aboutButton.setScale(ratio)
        
        titleLabel.name = "titleLabel"
        startGameButton.name = "startGameButton"
        settingButton.name = "settingButton"
        aboutButton.name = "aboutButton"
        
        titleLabel.position = CGPointMake(width / 2, height * 17 / 24 - titleLabel.frame.height / 2.0)
        settingButton.position = CGPointMake(width / 2, height / 3 - settingButton.frame.height * 1.5)
        startGameButton.position = CGPointMake(width / 2, settingButton.position.y + settingButton.frame.height * 1.5)
        aboutButton.position = CGPointMake(width - aboutButton.frame.width * 0.55, aboutButton.frame.height * 0.55)
        
        if backgroundDark.texture == nil {
            let num = Int(arc4random() % 5)
            backgroundDark = SKSpriteNode(texture: SKTexture(image: UIImage(CGImage: backgrounds[num].texture!.CGImage()).applyDarkEffect()))
            backgroundDark.size = CGSizeMake(width, height)
            backgroundDark.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            backgroundDark.zPosition = -1000
        }
        Background = backgroundDark.copy() as! SKSpriteNode
        
        self.addChild(Background)
        self.addChild(titleLabel)
        self.addChild(settingButton)
        self.addChild(startGameButton)
        self.addChild(aboutButton)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let particle = touch_particle[touch.hash]
            if (particle != nil) {
                particle!.runAction(SKAction.moveTo(location, duration: 0))
                particle!.particleBirthRate = 250 + 300 * touch.force
            }
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
            
            if node.name != nil {
                switch node.name!{
                case "startGameButton":
                    Scene = ChooseScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "settingButton":
                    Scene = SettingScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "aboutButton":
                    Scene = AboutScene(size : CGSizeMake(width, height))
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
