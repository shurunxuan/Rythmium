//
//  ChooseScene.swift
//  Rythmium
//
//  Created by 舒润萱 on 15/8/17.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import SpriteKit

class ChooseScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.Choose
        exporter.ChooseSong()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            
            // SKScene跳转
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
                background = SKSpriteNode(texture: SKTexture(image: exporter.Song().artwork!.resizedImage(size, interpolationQuality: CGInterpolationQuality.Low).applyDarkEffect()))
                //background.size = CGSize(width: 736, height: 414)
                background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                background.zPosition = -1000
            }
            Scene = AnalyzeScene(size : CGSizeMake(width, height))
            View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
        }
    }
}
