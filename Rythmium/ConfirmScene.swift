//
//  ConfirmScene.swift
//  Rythmium
//
//  Created by 舒润萱 on 15/8/17.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import SpriteKit

class ConfirmScene: SKScene {
    
    var titleButton = SKLabelNode(text: "Title")
    var startGameButton = SKLabelNode(text: "Start Game")
    var backButton = SKLabelNode(text: "Back")
    
    var easyLabel = SKLabelNode(text: "EASY")
    var normalLabel = SKLabelNode(text: "NORMAL")
    var hardLabel = SKLabelNode(text: "HARD")
    var insaneLabel = SKLabelNode(text: "INSANE")
    
    var albumArtwork = SKSpriteNode()
    var originalPosition = CGPoint()
    var originalScale: CGFloat = 0
    var scaled = false
    var scaleBackground = SKShapeNode()
    
    var bestScoreLabel = SKLabelNode(text: "BEST: 00000000")
    
    var rankLabel = SKSpriteNode()
    
    
    var Background = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.StartUp
        
        titleButton.fontName = "Helvetica Neue Thin"
        startGameButton.fontName = "Helvetica Neue Thin"
        backButton.fontName = "Helvetica Neue Thin"
        easyLabel.fontName = "Helvetica Neue UltraLight"
        normalLabel.fontName = "Helvetica Neue UltraLight"
        hardLabel.fontName = "Helvetica Neue UltraLight"
        insaneLabel.fontName = "Helvetica Neue UltraLight"
        bestScoreLabel.fontName = "Helvetica Neue Thin"
        
        titleButton.fontSize = 32 * ratio
        startGameButton.fontSize = 32 * ratio
        backButton.fontSize = 32 * ratio
        easyLabel.fontSize = 32 * ratio
        normalLabel.fontSize = 32 * ratio
        hardLabel.fontSize = 32 * ratio
        insaneLabel.fontSize = 32 * ratio
        bestScoreLabel.fontSize = 20 * ratio
        
        titleButton.name = "titleButton"
        startGameButton.name = "startGameButton"
        backButton.name = "backButton"
        easyLabel.name = "easyLabel"
        normalLabel.name = "normalLabel"
        hardLabel.name = "hardLabel"
        insaneLabel.name = "insaneLabel"
        bestScoreLabel.name = "bestScoreLabel"
        
        rankLabel = SKSpriteNode(imageNamed: "S")
        rankLabel.name = "rankLabel"
        rankLabel.setScale(1.2 * ratio)
        
        Background = background.copy() as! SKSpriteNode
        
        artViewBackground = exporter.Song().artwork
        //.imageWithSize(CGSize(width: 100, height: 100))
        if (artViewBackground != nil) {
            let backgroundWidth = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.width
            let backgroundHeight = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.height
            let size = CGSizeMake(backgroundWidth! / backgroundHeight! * height, height)
            albumArtwork = SKSpriteNode(texture: SKTexture(image: exporter.Song().artwork!.resizedImage(size, interpolationQuality: CGInterpolationQuality.High)))
            albumArtwork.name = "albumArtwork"
            albumArtwork.zPosition = 500
            albumArtwork.setScale(0.5)
            originalScale = 0.5
            //background.size = CGSize(width: 736, height: 414)
            originalPosition = CGPointMake(width / 5, height / 3 + size.height / 4)
            albumArtwork.position = originalPosition
            self.addChild(albumArtwork)
        }
        scaleBackground = SKShapeNode(rectOfSize: self.size)
        scaleBackground.fillColor = SKColor.blackColor()
        scaleBackground.zPosition = 499
        scaleBackground.alpha = 0
        scaleBackground.position = CGPointMake(width / 2, height / 2)
        scaleBackground.strokeColor = SKColor.clearColor()
        
        let dif = (albumArtwork.position.y + albumArtwork.frame.height / 2 - easyLabel.frame.height - height / 3) / 3
        
        titleButton.position = CGPointMake(width / 8 * 7, height / 8 - titleButton.frame.height / 2)
        startGameButton.position = CGPointMake(width / 2, height / 8 - startGameButton.frame.height / 2)
        backButton.position = CGPointMake(width / 8, height / 8 - backButton.frame.height / 2)
        easyLabel.position = CGPointMake(width - albumArtwork.position.x + albumArtwork.frame.width / 2 - easyLabel.frame.width / 2, height / 3 + 3 * dif)
        normalLabel.position = CGPointMake(width - albumArtwork.position.x + albumArtwork.frame.width / 2 - normalLabel.frame.width / 2, height / 3 + 2 * dif)
        hardLabel.position = CGPointMake(width - albumArtwork.position.x + albumArtwork.frame.width / 2 - hardLabel.frame.width / 2, height / 3 + dif)
        insaneLabel.position = CGPointMake(width - albumArtwork.position.x + albumArtwork.frame.width / 2 - insaneLabel.frame.width / 2, height / 3)
        bestScoreLabel.position = CGPointMake(((albumArtwork.position.x + albumArtwork.frame.width / 2) + (normalLabel.position.x - normalLabel.frame.width / 2)) / 2, insaneLabel.position.y)
        rankLabel.position = CGPointMake(bestScoreLabel.position.x, (albumArtwork.position.y + albumArtwork.frame.height / 2 + bestScoreLabel.position.y + bestScoreLabel.frame.height) / 15 * 8)
        
        self.addChild(Background)
        self.addChild(titleButton)
        self.addChild(startGameButton)
        self.addChild(backButton)
        self.addChild(easyLabel)
        self.addChild(normalLabel)
        self.addChild(hardLabel)
        self.addChild(insaneLabel)
        self.addChild(bestScoreLabel)
        self.addChild(rankLabel)
        
        self.addChild(scaleBackground)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            
            // SKScene跳转
            if node.name != nil {
                switch node.name!{
                case "albumArtwork" :
                    if !scaled {
                        scaled = true
                        var scale: CGFloat = 0
                        if (albumArtwork.frame.width / albumArtwork.frame.height) < (16.0 / 9.0) {
                            scale = height / albumArtwork.frame.height / 2
                        } else {
                            scale = width / albumArtwork.frame.width / 2
                        }
                        let action1 = SKAction.scaleTo(scale, duration: 0.5)
                        let action2 = SKAction.moveTo(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)), duration: 0.5)
                        let action3 = SKAction.fadeAlphaTo(1, duration: 0.5)
                        action1.timingMode = SKActionTimingMode.EaseOut
                        action2.timingMode = SKActionTimingMode.EaseOut
                        action3.timingMode = SKActionTimingMode.EaseOut
                        let action = SKAction.group([action1, action2])
                        albumArtwork.runAction(action)
                        
                        scaleBackground.runAction(action3)
                    } else {
                        scaled = false
                        let action1 = SKAction.scaleTo(originalScale, duration: 0.5)
                        let action2 = SKAction.moveTo(originalPosition, duration: 0.5)
                        let action3 = SKAction.fadeAlphaTo(0, duration: 0.5)
                        action1.timingMode = SKActionTimingMode.EaseOut
                        action2.timingMode = SKActionTimingMode.EaseOut
                        action3.timingMode = SKActionTimingMode.EaseOut
                        let action = SKAction.group([action1, action2])
                        albumArtwork.runAction(action)
                        scaleBackground.runAction(action3)
                    }
                case "startGameButton" :
                    Scene = AnalyzeScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "backButton" :
                    Scene = ChooseScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "titleButton" :
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

