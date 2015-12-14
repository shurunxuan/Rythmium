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
    var scaling: CGFloat = 0
    var scaled = false
    var scaleBackground = SKShapeNode()
    
    var bestScoreLabel = SKLabelNode(text: "BEST: ????????")
    
    var rankLabel = SKSpriteNode()
    
    
    var Background = SKSpriteNode()
    
    var difficultyIndicator = [SKShapeNode(), SKShapeNode(), SKShapeNode(), SKShapeNode()]
    
    
    var touch_particle: [Int : SKEmitterNode] = [:]
    

    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.StartUp

        titleButton.fontName = "SFUIDisplay-Thin"
        startGameButton.fontName = "SFUIDisplay-Thin"
        backButton.fontName = "SFUIDisplay-Thin"
        easyLabel.fontName = "SFUIDisplay-Ultralight"
        normalLabel.fontName = "SFUIDisplay-Ultralight"
        hardLabel.fontName = "SFUIDisplay-Ultralight"
        insaneLabel.fontName = "SFUIDisplay-Ultralight"
        bestScoreLabel.fontName = "SFUIDisplay-Thin"
        
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
        
        rankLabel = SKSpriteNode(imageNamed: "Q")
        
        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
            hasBestScore = true
            let bsFile = FileClass()
            bsFile.OpenFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
            let string = bsFile.Read()
            let strList = string.componentsSeparatedByString("\t")
            bestScore = Int(strList[1])!
            bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String
            rankLabel = SKSpriteNode(imageNamed: strList[0])
        }
        
        rankLabel.name = "rankLabel"

        rankLabel.setScale(1.2 * ratio)
        
        Background = backgroundDark.copy() as! SKSpriteNode
        
        var dif: CGFloat = 0
        
        artViewBackground = exporter.Song().artwork
        //.imageWithSize(CGSize(width: 100, height: 100))
        if (artViewBackground != nil) {
            let backgroundWidth = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.width
            let backgroundHeight = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.height
            let size = CGSizeMake(backgroundWidth! / backgroundHeight! * height * 2, height * 2)
            albumArtwork = SKSpriteNode(texture: SKTexture(image: exporter.Song().artwork!.imageWithSize(size)!.resizedImage(size, interpolationQuality: CGInterpolationQuality.High)))
            albumArtwork.name = "albumArtwork"
            albumArtwork.zPosition = 500
            albumArtwork.setScale(0.25)
            originalScale = 0.25
            //background.size = CGSize(width: 736, height: 414)
            originalPosition = CGPointMake(width / 5, height / 3 + size.height / 8)
            albumArtwork.position = originalPosition
            if (albumArtwork.frame.width / albumArtwork.frame.height) < (width / height) {
                scaling = height / albumArtwork.frame.height / 4
            } else {
                scaling = width / albumArtwork.frame.width / 4
            }
            self.addChild(albumArtwork)
            dif = (albumArtwork.position.y + albumArtwork.frame.height / 2 - easyLabel.frame.height - height / 3) / 3
            //print(albumArtwork.position.y)
            //print(albumArtwork.frame.height)
            easyLabel.position = CGPointMake(width - albumArtwork.position.x + albumArtwork.frame.width / 2 - easyLabel.frame.width / 2, height / 3 + 3 * dif)
            normalLabel.position = CGPointMake(width - albumArtwork.position.x + albumArtwork.frame.width / 2 - normalLabel.frame.width / 2, height / 3 + 2 * dif)
            hardLabel.position = CGPointMake(width - albumArtwork.position.x + albumArtwork.frame.width / 2 - hardLabel.frame.width / 2, height / 3 + dif)
            insaneLabel.position = CGPointMake(width - albumArtwork.position.x + albumArtwork.frame.width / 2 - insaneLabel.frame.width / 2, height / 3)
            bestScoreLabel.position = CGPointMake(((albumArtwork.position.x + albumArtwork.frame.width / 2) + (normalLabel.position.x - normalLabel.frame.width / 2)) / 2, insaneLabel.position.y)
            rankLabel.position = CGPointMake(bestScoreLabel.position.x, (dif * 3 + height / 3 + easyLabel.frame.height + bestScoreLabel.position.y + bestScoreLabel.frame.height) / 15 * 8)
        } else {
            dif = ((241.5 + 207.0 / 2) * ratio - easyLabel.frame.height - height / 3) / 3
            normalLabel.position = CGPointMake(width / 3 * 2 + normalLabel.frame.width / 2, height / 3 + 2 * dif)
            easyLabel.position = CGPointMake(width / 3 * 2 + normalLabel.frame.width - easyLabel.frame.width / 2, height / 3 + 3 * dif)
            hardLabel.position = CGPointMake(width / 3 * 2 + normalLabel.frame.width - hardLabel.frame.width / 2, height / 3 + dif)
            insaneLabel.position = CGPointMake(width / 3 * 2 + normalLabel.frame.width - insaneLabel.frame.width / 2, height / 3)
            bestScoreLabel.position = CGPointMake(width / 24 * 7, insaneLabel.position.y)
            rankLabel.position = CGPointMake(bestScoreLabel.position.x, (dif * 3 + height / 3 + easyLabel.frame.height + bestScoreLabel.position.y + bestScoreLabel.frame.height) / 15 * 8)
        }
        scaleBackground = SKShapeNode(rectOfSize: self.size)
        scaleBackground.fillColor = SKColor.blackColor()
        scaleBackground.zPosition = 499
        scaleBackground.alpha = 0
        scaleBackground.position = CGPointMake(width / 2, height / 2)
        scaleBackground.strokeColor = SKColor.clearColor()
        scaleBackground.name = "scaleBackground"
        
        
        
        titleButton.position = CGPointMake(width / 8 * 7, height / 8 - titleButton.frame.height / 2)
        startGameButton.position = CGPointMake(width / 2, height / 8 - startGameButton.frame.height / 2)
        backButton.position = CGPointMake(width / 8, height / 8 - backButton.frame.height / 2)
        
        
        
        difficultyIndicator[0] = SKShapeNode(rect: CGRectMake(easyLabel.position.x - easyLabel.frame.width / 2 - 5 * ratio, height / 3 + 3 * dif - 5 * ratio, easyLabel.frame.width + 10 * ratio, easyLabel.frame.height + 10 * ratio), cornerRadius: 5)
        difficultyIndicator[1] = SKShapeNode(rect: CGRectMake(normalLabel.position.x - normalLabel.frame.width / 2 - 5 * ratio, height / 3 + 2 * dif - 5 * ratio, normalLabel.frame.width + 10 * ratio, normalLabel.frame.height + 10 * ratio), cornerRadius: 5)
        difficultyIndicator[2] = SKShapeNode(rect: CGRectMake(hardLabel.position.x - hardLabel.frame.width / 2 - 5 * ratio, height / 3 + dif - 5 * ratio, hardLabel.frame.width + 10 * ratio, hardLabel.frame.height + 10 * ratio), cornerRadius: 5)
        difficultyIndicator[3] = SKShapeNode(rect: CGRectMake(insaneLabel.position.x - insaneLabel.frame.width / 2 - 5 * ratio, height / 3 - 5 * ratio, insaneLabel.frame.width + 10 * ratio, insaneLabel.frame.height + 10 * ratio), cornerRadius: 5)
        
        difficultyIndicator[0].name = "easyIndicator"
        difficultyIndicator[1].name = "normalIndicator"
        difficultyIndicator[2].name = "hardIndicator"
        difficultyIndicator[3].name = "insaneIndicator"
        
        for indicator in difficultyIndicator {
            indicator.strokeColor = SKColor.clearColor()
            indicator.fillColor = SKColor.whiteColor()
            indicator.alpha = 0.2
        }
        
        switch difficultyType {
        case difficulty.easy:
            addChild(difficultyIndicator[0])
        case difficulty.normal:
            addChild(difficultyIndicator[1])
        case difficulty.hard:
            addChild(difficultyIndicator[2])
        case difficulty.insane:
            addChild(difficultyIndicator[3])
        default:
            break
        }
        
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
                case "albumArtwork" :
                    if !scaled {
                        scaled = true
                        let action1 = SKAction.scaleTo(scaling, duration: 0.5)
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
                case "scaleBackground" :
                    if scaled {
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
                case  "easyLabel":
                    if difficultyType != difficulty.easy {
                        for indicator in difficultyIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        difficultyIndicator[0].removeAllActions()
                        difficultyIndicator[0].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(difficultyIndicator[0])
                        difficultyType = difficulty.easy
                        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
                            hasBestScore = true
                            let bsFile = FileClass()
                            bsFile.OpenFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                            let string = bsFile.Read()
                            let strList = string.componentsSeparatedByString("\t")
                            bestScore = Int(strList[1])!
                            bestScoreLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.runBlock({self.bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String}), SKAction.fadeInWithDuration(0.25)]))
                            
                            rankLabel.removeAllActions()
                            rankLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.setTexture(SKTexture(imageNamed: strList[0])), SKAction.fadeInWithDuration(0.25)]))
                        } else {
                            hasBestScore = false
                            bestScoreLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.runBlock({self.bestScoreLabel.text = "BEST: ????????"}), SKAction.fadeInWithDuration(0.25)]))
                            
                            rankLabel.removeAllActions()
                            rankLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.setTexture(SKTexture(imageNamed: "Q")), SKAction.fadeInWithDuration(0.25)]))
                        }
                        settings["Difficulty"] = "easy"
                    }
                case  "normalLabel":
                    if difficultyType != difficulty.normal {
                        for indicator in difficultyIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        difficultyIndicator[1].removeAllActions()
                        difficultyIndicator[1].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(difficultyIndicator[1])
                        difficultyType = difficulty.normal
                        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
                            hasBestScore = true
                            let bsFile = FileClass()
                            bsFile.OpenFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                            let string = bsFile.Read()
                            let strList = string.componentsSeparatedByString("\t")
                            bestScore = Int(strList[1])!
                            bestScoreLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.runBlock({self.bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String}), SKAction.fadeInWithDuration(0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.setTexture(SKTexture(imageNamed: strList[0])), SKAction.fadeInWithDuration(0.25)]))
                        } else {
                            hasBestScore = false
                            bestScoreLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.runBlock({self.bestScoreLabel.text = "BEST: ????????"}), SKAction.fadeInWithDuration(0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.setTexture(SKTexture(imageNamed: "Q")), SKAction.fadeInWithDuration(0.25)]))
                        }
                        settings["Difficulty"] = "normal"
                    }
                case  "hardLabel":
                    if difficultyType != difficulty.hard {
                        for indicator in difficultyIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        difficultyIndicator[2].removeAllActions()
                        difficultyIndicator[2].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(difficultyIndicator[2])
                        difficultyType = difficulty.hard
                        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
                            hasBestScore = true
                            let bsFile = FileClass()
                            bsFile.OpenFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                            let string = bsFile.Read()
                            let strList = string.componentsSeparatedByString("\t")
                            bestScore = Int(strList[1])!
                            bestScoreLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.runBlock({self.bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String}), SKAction.fadeInWithDuration(0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.setTexture(SKTexture(imageNamed: strList[0])), SKAction.fadeInWithDuration(0.25)]))
                        } else {
                            hasBestScore = false
                            bestScoreLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.runBlock({self.bestScoreLabel.text = "BEST: ????????"}), SKAction.fadeInWithDuration(0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.setTexture(SKTexture(imageNamed: "Q")), SKAction.fadeInWithDuration(0.25)]))
                        }
                        settings["Difficulty"] = "hard"
                    }
                case  "insaneLabel":
                    if difficultyType != difficulty.insane {
                        for indicator in difficultyIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        difficultyIndicator[3].removeAllActions()
                        difficultyIndicator[3].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(difficultyIndicator[3])
                        difficultyType = difficulty.insane
                        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
                            hasBestScore = true
                            let bsFile = FileClass()
                            bsFile.OpenFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                            let string = bsFile.Read()
                            let strList = string.componentsSeparatedByString("\t")
                            bestScore = Int(strList[1])!
                            bestScoreLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.runBlock({self.bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String}), SKAction.fadeInWithDuration(0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.setTexture(SKTexture(imageNamed: strList[0])), SKAction.fadeInWithDuration(0.25)]))
                        } else {
                            hasBestScore = false
                            bestScoreLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.runBlock({self.bestScoreLabel.text = "BEST: ????????"}), SKAction.fadeInWithDuration(0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.25), SKAction.setTexture(SKTexture(imageNamed: "Q")), SKAction.fadeInWithDuration(0.25)]))
                        }
                        settings["Difficulty"] = "insane"
                    }
                case "bestScoreLabel" :
                    difficultyType = difficulty.custom
                    Scene = AnalyzeScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "startGameButton" :
                    SaveSetting()
                    Scene = AnalyzeScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "backButton" :
                    Scene = ChooseScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "titleButton" :
                    Scene = StartUpScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "rankLabel" :
                    Scene = CustomScene(size : CGSizeMake(width, height))
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

