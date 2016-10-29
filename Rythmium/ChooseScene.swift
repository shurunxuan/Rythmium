//
//  ChooseScene.swift
//  Rythmium
//
//  Created by 舒润萱 on 15/8/17.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import SpriteKit

class ChooseScene: SKScene {
    var Background = SKSpriteNode()
    
    var touch_particle: [Int : SKEmitterNode] = [:]
    
    
    override func didMove(to view: SKView) {
        
        Stage = GameStage.choose
        Background = backgroundDark.copy() as! SKSpriteNode
        addChild(Background)
        exporter.chooseSong()
        
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
                    Scene = AnalyzeScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case "settingButton":
                    Scene = SettingScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                default:
                    break
                }
            }
            
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if exporter.isDone() {
            if exporter.isDismissed() {
                Scene = StartUpScene(size : CGSize(width: width, height: height))
                View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                return
            }
            exporter.setEnd()
            artViewBackground = exporter.song().artwork
            //.imageWithSize(CGSize(width: 100, height: 100))
            if (artViewBackground != nil) {
                let backgroundWidth = artViewBackground?.image(at: CGSize(width: 100, height: 100))!.size.width
                let backgroundHeight = artViewBackground?.image(at: CGSize(width: 100, height: 100))!.size.height
                var size = CGSize()
                if (backgroundWidth! / backgroundHeight!) < (16.0 / 9.0) {
                    size = CGSize(width: width, height: width / backgroundWidth! * backgroundHeight!)
                } else {
                    size = CGSize(width: height / backgroundHeight! * backgroundWidth!, height: height)
                }
                backgroundDark = SKSpriteNode(texture: SKTexture(image: exporter.song().artwork!.image(at: size)!.resizedImage(size, interpolationQuality: CGInterpolationQuality.low).applyDarkEffect()))
                backgroundDark.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                backgroundDark.zPosition = -1000
                isNormalBackground = false
            } else if !isNormalBackground {
                isNormalBackground = true
                let num = Int(arc4random() % 5)
                backgroundDark = SKSpriteNode(texture: SKTexture(image: UIImage(cgImage: backgrounds[num].texture!.cgImage()).applyDarkEffect()))
                backgroundDark.size = CGSize(width: width, height: height)
                backgroundDark.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                backgroundDark.zPosition = -1000
            }
            Background.removeFromParent()
            Background = backgroundDark.copy() as! SKSpriteNode
            self.addChild(Background)
            Scene = ConfirmScene(size : CGSize(width: width, height: height))
            View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
        }
    }
}
