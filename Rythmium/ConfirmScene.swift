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
    
    var rankLabel = SKSpriteNode()
    
    var bestScoreLabel = SKLabelNode(text: "BEST: ????????")
    
    var albumArtwork = SKSpriteNode()
    
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
        
        if FileClass.isExist(String(exporter.songID())+".bs") {
            hasBestScore = true
            let bsFile = FileClass()
            bsFile.OpenFile(String(exporter.songID())+".bs")
            let string = bsFile.Read()
            print(string)
            let strList = string.componentsSeparatedByString("\t")
            print(strList)
            bestScore = Int(strList[1])!
            bestScoreLabel.text = NSString(format: "BEST: %08i", bestScore) as String
            rankLabel = SKSpriteNode(imageNamed: strList[0])
        }
        
        rankLabel.setScale(1.2 * ratio)
        
        Background = background.copy() as! SKSpriteNode
        
        artViewBackground = exporter.Song().artwork
        //.imageWithSize(CGSize(width: 100, height: 100))
        if (artViewBackground != nil) {
            let backgroundWidth = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.width
            let backgroundHeight = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.height
            let size = CGSizeMake(backgroundWidth! / backgroundHeight! * height, height)
            albumArtwork = SKSpriteNode(texture: SKTexture(image: exporter.Song().artwork!.resizedImage(size, interpolationQuality: CGInterpolationQuality.High)))
            albumArtwork.setScale(0.5)
            //background.size = CGSize(width: 736, height: 414)
            albumArtwork.position = CGPointMake(width / 5, height / 3 + size.height / 4)
            self.addChild(albumArtwork)
        }
        
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
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            
            // SKScene跳转
            if node.name != nil {
                switch node.name!{
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

