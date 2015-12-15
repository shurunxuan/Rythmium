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
    
    
    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.Choose
        Background = backgroundDark.copy() as! SKSpriteNode
        addChild(Background)
        exporter.ChooseSong()
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
                    Scene = AnalyzeScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "settingButton":
                    Scene = SettingScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                default:
                    break
                }
            }
            
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if exporter.isDone() {
            if exporter.isDismissed() {
                Scene = StartUpScene(size : CGSizeMake(width, height))
                View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                return
            }
            exporter.setEnd()
            artViewBackground = exporter.Song().artwork
            //.imageWithSize(CGSize(width: 100, height: 100))
            if (artViewBackground != nil) {
                let backgroundWidth = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.width
                let backgroundHeight = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.height
                var size = CGSize()
                if (backgroundWidth! / backgroundHeight!) < (16.0 / 9.0) {
                    size = CGSizeMake(width, width / backgroundWidth! * backgroundHeight!)
                } else {
                    size = CGSizeMake(height / backgroundHeight! * backgroundWidth!, height)
                }
                backgroundDark = SKSpriteNode(texture: SKTexture(image: exporter.Song().artwork!.imageWithSize(size)!.resizedImage(size, interpolationQuality: CGInterpolationQuality.Low).applyDarkEffect()))
                backgroundDark.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                backgroundDark.zPosition = -1000
                isNormalBackground = false
            } else if !isNormalBackground {
                isNormalBackground = true
                let num = Int(arc4random() % 5)
                backgroundDark = SKSpriteNode(texture: SKTexture(image: UIImage(CGImage: backgrounds[num].texture!.CGImage()).applyDarkEffect()))
                backgroundDark.size = CGSizeMake(width, height)
                backgroundDark.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                backgroundDark.zPosition = -1000
            }
            Background.removeFromParent()
            Background = backgroundDark.copy() as! SKSpriteNode
            self.addChild(Background)
            Scene = ConfirmScene(size : CGSizeMake(width, height))
            View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
        }
    }
}
