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
    
    var bestScoreLabel = SKLabelNode(text: "BEST: 00000000")
    
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
        
        titleButton.position = CGPointMake(width / 8 * 7, height / 8 - titleButton.frame.height / 2)
        startGameButton.position = CGPointMake(width / 2, height / 8 - startGameButton.frame.height / 2)
        backButton.position = CGPointMake(width / 8, height / 8 - backButton.frame.height / 2)
        easyLabel.position = CGPointMake(width / 12 * 11 - easyLabel.frame.width / 2, height / 16 * 11 - easyLabel.frame.height / 2)
        normalLabel.position = CGPointMake(width / 12 * 11 - normalLabel.frame.width / 2, height / 16 * 9 - normalLabel.frame.height / 2)
        hardLabel.position = CGPointMake(width / 12 * 11 - hardLabel.frame.width / 2, height / 16 * 7 - hardLabel.frame.height / 2)
        insaneLabel.position = CGPointMake(width / 12 * 11 - insaneLabel.frame.width / 2, height / 16 * 5 - insaneLabel.frame.height / 2)
        bestScoreLabel.position = CGPointMake(width / 24 * 13, insaneLabel.position.y)
        
        Background = background.copy() as! SKSpriteNode
        
        self.addChild(Background)
        self.addChild(titleButton)
        self.addChild(startGameButton)
        self.addChild(backButton)
        self.addChild(easyLabel)
        self.addChild(normalLabel)
        self.addChild(hardLabel)
        self.addChild(insaneLabel)
        self.addChild(bestScoreLabel)
        
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

