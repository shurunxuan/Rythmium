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
    
    override func didMove(to view: SKView) {
        
        Stage = GameStage.startUp
        
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
        
        titleLabel.position = CGPoint(x: width / 2, y: height * 17 / 24 - titleLabel.frame.height / 2.0)
        settingButton.position = CGPoint(x: width / 2, y: height / 3 - settingButton.frame.height * 1.5)
        startGameButton.position = CGPoint(x: width / 2, y: settingButton.position.y + settingButton.frame.height * 1.5)
        aboutButton.position = CGPoint(x: width - aboutButton.frame.width * 0.55, y: aboutButton.frame.height * 0.55)
        
        if backgroundDark.texture == nil {
            let num = Int(arc4random() % 5)
            backgroundDark = SKSpriteNode(texture: SKTexture(image: UIImage(cgImage: backgrounds[num].texture!.cgImage()).applyDarkEffect()))
            backgroundDark.size = CGSize(width: width, height: height)
            backgroundDark.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            backgroundDark.zPosition = -1000
        }
        Background = backgroundDark.copy() as! SKSpriteNode
        
        self.addChild(Background)
        self.addChild(titleLabel)
        self.addChild(settingButton)
        self.addChild(startGameButton)
        //self.addChild(aboutButton)
        
        restarted = false
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
                case "startGameButton":
                    Scene = ChooseScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case "settingButton":
                    Scene = SettingScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case "aboutButton":
                    Scene = AboutScene(size : CGSize(width: width, height: height))
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
