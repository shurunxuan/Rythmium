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
    

    override func didMove(to view: SKView) {
        
        Stage = GameStage.startUp

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
        //bestScoreLabel.name = "bestScoreLabel"
        
        rankLabel = SKSpriteNode(imageNamed: "Q")
        
        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
            hasBestScore = true
            let bsFile = FileClass()
            bsFile.openFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
            let string = bsFile.read()
            let strList = string?.components(separatedBy: "\t")
            bestScore = Int((strList?[1])!)!
            bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String
            rankLabel = SKSpriteNode(imageNamed: (strList?[0])!)
        }
        
        //rankLabel.name = "rankLabel"

        rankLabel.setScale(1.2 * ratio)
        
        Background = backgroundDark.copy() as! SKSpriteNode
        
        var dif: CGFloat = 0
        
        artViewBackground = exporter.song().artwork
        //.imageWithSize(CGSize(width: 100, height: 100))
        if (artViewBackground != nil) {
            let backgroundWidth = artViewBackground?.image(at: CGSize(width: 100, height: 100))!.size.width
            let backgroundHeight = artViewBackground?.image(at: CGSize(width: 100, height: 100))!.size.height
            let size = CGSize(width: backgroundWidth! / backgroundHeight! * height * 2, height: height * 2)
            albumArtwork = SKSpriteNode(texture: SKTexture(image: exporter.song().artwork!.image(at: size)!.resizedImage(size, interpolationQuality: CGInterpolationQuality.high)))
            albumArtwork.name = "albumArtwork"
            albumArtwork.zPosition = 500
            albumArtwork.setScale(0.25)
            originalScale = 0.25
            //background.size = CGSize(width: 736, height: 414)
            originalPosition = CGPoint(x: width / 5, y: height / 3 + size.height / 8)
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
            easyLabel.position = CGPoint(x: width - albumArtwork.position.x + albumArtwork.frame.width / 2 - easyLabel.frame.width / 2, y: height / 3 + 3 * dif)
            normalLabel.position = CGPoint(x: width - albumArtwork.position.x + albumArtwork.frame.width / 2 - normalLabel.frame.width / 2, y: height / 3 + 2 * dif)
            hardLabel.position = CGPoint(x: width - albumArtwork.position.x + albumArtwork.frame.width / 2 - hardLabel.frame.width / 2, y: height / 3 + dif)
            insaneLabel.position = CGPoint(x: width - albumArtwork.position.x + albumArtwork.frame.width / 2 - insaneLabel.frame.width / 2, y: height / 3)
            bestScoreLabel.position = CGPoint(x: ((albumArtwork.position.x + albumArtwork.frame.width / 2) + (normalLabel.position.x - normalLabel.frame.width / 2)) / 2, y: insaneLabel.position.y)
            rankLabel.position = CGPoint(x: bestScoreLabel.position.x, y: (dif * 3 + height / 3 + easyLabel.frame.height + bestScoreLabel.position.y + bestScoreLabel.frame.height) / 15 * 8)
        } else {
            dif = ((241.5 + 207.0 / 2) * ratio - easyLabel.frame.height - height / 3) / 3
            normalLabel.position = CGPoint(x: width / 3 * 2 + normalLabel.frame.width / 2, y: height / 3 + 2 * dif)
            easyLabel.position = CGPoint(x: width / 3 * 2 + normalLabel.frame.width - easyLabel.frame.width / 2, y: height / 3 + 3 * dif)
            hardLabel.position = CGPoint(x: width / 3 * 2 + normalLabel.frame.width - hardLabel.frame.width / 2, y: height / 3 + dif)
            insaneLabel.position = CGPoint(x: width / 3 * 2 + normalLabel.frame.width - insaneLabel.frame.width / 2, y: height / 3)
            bestScoreLabel.position = CGPoint(x: width / 24 * 7, y: insaneLabel.position.y)
            rankLabel.position = CGPoint(x: bestScoreLabel.position.x, y: (dif * 3 + height / 3 + easyLabel.frame.height + bestScoreLabel.position.y + bestScoreLabel.frame.height) / 15 * 8)
        }
        scaleBackground = SKShapeNode(rectOf: self.size)
        scaleBackground.fillColor = SKColor.black
        scaleBackground.zPosition = 499
        scaleBackground.alpha = 0
        scaleBackground.position = CGPoint(x: width / 2, y: height / 2)
        scaleBackground.strokeColor = SKColor.clear
        scaleBackground.name = "scaleBackground"
        
        
        
        titleButton.position = CGPoint(x: width / 8 * 7, y: height / 8 - titleButton.frame.height / 2)
        startGameButton.position = CGPoint(x: width / 2, y: height / 8 - startGameButton.frame.height / 2)
        backButton.position = CGPoint(x: width / 8, y: height / 8 - backButton.frame.height / 2)
        
        
        
        difficultyIndicator[0] = SKShapeNode(rect: CGRect(x: easyLabel.position.x - easyLabel.frame.width / 2 - 5 * ratio, y: height / 3 + 3 * dif - 5 * ratio, width: easyLabel.frame.width + 10 * ratio, height: easyLabel.frame.height + 10 * ratio), cornerRadius: 5)
        difficultyIndicator[1] = SKShapeNode(rect: CGRect(x: normalLabel.position.x - normalLabel.frame.width / 2 - 5 * ratio, y: height / 3 + 2 * dif - 5 * ratio, width: normalLabel.frame.width + 10 * ratio, height: normalLabel.frame.height + 10 * ratio), cornerRadius: 5)
        difficultyIndicator[2] = SKShapeNode(rect: CGRect(x: hardLabel.position.x - hardLabel.frame.width / 2 - 5 * ratio, y: height / 3 + dif - 5 * ratio, width: hardLabel.frame.width + 10 * ratio, height: hardLabel.frame.height + 10 * ratio), cornerRadius: 5)
        difficultyIndicator[3] = SKShapeNode(rect: CGRect(x: insaneLabel.position.x - insaneLabel.frame.width / 2 - 5 * ratio, y: height / 3 - 5 * ratio, width: insaneLabel.frame.width + 10 * ratio, height: insaneLabel.frame.height + 10 * ratio), cornerRadius: 5)
        
        difficultyIndicator[0].name = "easyIndicator"
        difficultyIndicator[1].name = "normalIndicator"
        difficultyIndicator[2].name = "hardIndicator"
        difficultyIndicator[3].name = "insaneIndicator"
        
        for indicator in difficultyIndicator {
            indicator.strokeColor = SKColor.clear
            indicator.fillColor = SKColor.white
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
                case "albumArtwork" :
                    if !scaled {
                        scaled = true
                        let action1 = SKAction.scale(to: scaling, duration: 0.5)
                        let action2 = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY), duration: 0.5)
                        let action3 = SKAction.fadeAlpha(to: 1, duration: 0.5)
                        action1.timingMode = SKActionTimingMode.easeOut
                        action2.timingMode = SKActionTimingMode.easeOut
                        action3.timingMode = SKActionTimingMode.easeOut
                        let action = SKAction.group([action1, action2])
                        albumArtwork.run(action)
                        
                        scaleBackground.run(action3)
                    } else {
                        scaled = false
                        let action1 = SKAction.scale(to: originalScale, duration: 0.5)
                        let action2 = SKAction.move(to: originalPosition, duration: 0.5)
                        let action3 = SKAction.fadeAlpha(to: 0, duration: 0.5)
                        action1.timingMode = SKActionTimingMode.easeOut
                        action2.timingMode = SKActionTimingMode.easeOut
                        action3.timingMode = SKActionTimingMode.easeOut
                        let action = SKAction.group([action1, action2])
                        albumArtwork.run(action)
                        scaleBackground.run(action3)
                    }
                case "scaleBackground" :
                    if scaled {
                        scaled = false
                        let action1 = SKAction.scale(to: originalScale, duration: 0.5)
                        let action2 = SKAction.move(to: originalPosition, duration: 0.5)
                        let action3 = SKAction.fadeAlpha(to: 0, duration: 0.5)
                        action1.timingMode = SKActionTimingMode.easeOut
                        action2.timingMode = SKActionTimingMode.easeOut
                        action3.timingMode = SKActionTimingMode.easeOut
                        let action = SKAction.group([action1, action2])
                        albumArtwork.run(action)
                        scaleBackground.run(action3)
                    }
                case  "easyLabel":
                    if difficultyType != difficulty.easy {
                        for indicator in difficultyIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        difficultyIndicator[0].removeAllActions()
                        difficultyIndicator[0].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(difficultyIndicator[0])
                        difficultyType = difficulty.easy
                        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
                            hasBestScore = true
                            let bsFile = FileClass()
                            bsFile.openFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                            let string = bsFile.read()
                            let strList = string?.components(separatedBy: "\t")
                            bestScore = Int((strList?[1])!)!
                            bestScoreLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.run({self.bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String}), SKAction.fadeIn(withDuration: 0.25)]))
                            
                            rankLabel.removeAllActions()
                            rankLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.setTexture(SKTexture(imageNamed: (strList?[0])!)), SKAction.fadeIn(withDuration: 0.25)]))
                        } else {
                            hasBestScore = false
                            bestScoreLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.run({self.bestScoreLabel.text = "BEST: ????????"}), SKAction.fadeIn(withDuration: 0.25)]))
                            
                            rankLabel.removeAllActions()
                            rankLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.setTexture(SKTexture(imageNamed: "Q")), SKAction.fadeIn(withDuration: 0.25)]))
                        }
                        settings["Difficulty"] = "easy"
                    }
                case "normalLabel":
                    if difficultyType != difficulty.normal {
                        for indicator in difficultyIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        difficultyIndicator[1].removeAllActions()
                        difficultyIndicator[1].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(difficultyIndicator[1])
                        difficultyType = difficulty.normal
                        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
                            hasBestScore = true
                            let bsFile = FileClass()
                            bsFile.openFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                            let string = bsFile.read()
                            let strList = string?.components(separatedBy: "\t")
                            bestScore = Int((strList?[1])!)!
                            bestScoreLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.run({self.bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String}), SKAction.fadeIn(withDuration: 0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.setTexture(SKTexture(imageNamed: (strList?[0])!)), SKAction.fadeIn(withDuration: 0.25)]))
                        } else {
                            hasBestScore = false
                            bestScoreLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.run({self.bestScoreLabel.text = "BEST: ????????"}), SKAction.fadeIn(withDuration: 0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.setTexture(SKTexture(imageNamed: "Q")), SKAction.fadeIn(withDuration: 0.25)]))
                        }
                        settings["Difficulty"] = "normal"
                    }
                case "hardLabel":
                    if difficultyType != difficulty.hard {
                        for indicator in difficultyIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        difficultyIndicator[2].removeAllActions()
                        difficultyIndicator[2].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(difficultyIndicator[2])
                        difficultyType = difficulty.hard
                        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
                            hasBestScore = true
                            let bsFile = FileClass()
                            bsFile.openFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                            let string = bsFile.read()
                            let strList = string?.components(separatedBy: "\t")
                            bestScore = Int((strList?[1])!)!
                            bestScoreLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.run({self.bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String}), SKAction.fadeIn(withDuration: 0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.setTexture(SKTexture(imageNamed: (strList?[0])!)), SKAction.fadeIn(withDuration: 0.25)]))
                        } else {
                            hasBestScore = false
                            bestScoreLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.run({self.bestScoreLabel.text = "BEST: ????????"}), SKAction.fadeIn(withDuration: 0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.setTexture(SKTexture(imageNamed: "Q")), SKAction.fadeIn(withDuration: 0.25)]))
                        }
                        settings["Difficulty"] = "hard"
                    }
                case "insaneLabel":
                    if difficultyType != difficulty.insane {
                        for indicator in difficultyIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        difficultyIndicator[3].removeAllActions()
                        difficultyIndicator[3].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(difficultyIndicator[3])
                        difficultyType = difficulty.insane
                        if FileClass.isExist(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs") {
                            hasBestScore = true
                            let bsFile = FileClass()
                            bsFile.openFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                            let string = bsFile.read()
                            let strList = string?.components(separatedBy: "\t")
                            bestScore = Int((strList?[1])!)!
                            bestScoreLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.run({self.bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String}), SKAction.fadeIn(withDuration: 0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.setTexture(SKTexture(imageNamed: (strList?[0])!)), SKAction.fadeIn(withDuration: 0.25)]))
                        } else {
                            hasBestScore = false
                            bestScoreLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.run({self.bestScoreLabel.text = "BEST: ????????"}), SKAction.fadeIn(withDuration: 0.25)]))
                            rankLabel.removeAllActions()
                            rankLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.setTexture(SKTexture(imageNamed: "Q")), SKAction.fadeIn(withDuration: 0.25)]))
                        }
                        settings["Difficulty"] = "insane"
                    }
                case "bestScoreLabel" :
                    difficultyType = difficulty.custom
                    Scene = AnalyzeScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case "startGameButton" :
                    SaveSetting()
                    Scene = AnalyzeScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case "backButton" :
                    Scene = ChooseScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case "titleButton" :
                    Scene = StartUpScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case "rankLabel" :
                    Scene = CustomScene(size : CGSize(width: width, height: height))
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

