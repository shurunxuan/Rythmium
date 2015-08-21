//
//  ResultScene.swift
//  UntitledMusicGame
//
//  Created by 舒润萱 on 15/7/7.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import SpriteKit

class ResultScene: SKScene {
    
    var resultNode = SKNode()
    var Background = SKSpriteNode()
    var isGameOver = false
    var rank = "F"
    override func didMoveToView(view: SKView) {
        Stage = GameStage.Result
        
        Background = background.copy() as! SKSpriteNode
        var rankLabel = SKSpriteNode()
        let percentage = Double(score) / Double(totalScore) * 100
        if percentage > 95 { rank = "S" }
        else if percentage > 90 { rank = "A" }
        else if percentage > 80 { rank = "B" }
        else if percentage > 70 { rank = "C" }
        else { rank = "D" }
        if fullCombo { rank = "SS" }
        if isGameOver { rank = "F" }
        rankLabel = SKSpriteNode(imageNamed: rank)
        rankLabel.setScale(ratio * 1.5)
        rankLabel.position = CGPointMake(width / 24 * 7, height / 3 * 2)
        resultNode.addChild(rankLabel)
        
        if hasBestScore {
            if score > bestScore {
                let bsFile = FileClass()
                bsFile.OpenFile(String(exporter.songID())+".bs")
                bsFile.Write(rank + "\t" + String(score))
            }
        } else {
            let bsFile = FileClass()
            bsFile.CreateFile(String(exporter.songID())+".bs")
            bsFile.Write(rank + "\t" + String(score))
        }
        
        let scoreLabel = SKLabelNode()
        scoreLabel.text = NSString(format: "SCORE: %08i", score) as String
        scoreLabel.fontSize = ratio * 30
        scoreLabel.position = CGPointMake(width / 24 * 7, height / 3)
        resultNode.addChild(scoreLabel)
        
        let maxComboLabel = SKLabelNode()
        maxComboLabel.text = NSString(format: "Max Combo: %i", maxCombo) as String
        if fullCombo { maxComboLabel.text = "FULL COMBO"; maxComboLabel.fontName = "Helvetica Neue Light" }
        maxComboLabel.fontSize = ratio * 30
        maxComboLabel.position = CGPointMake(width / 24 * 7, height / 4)
        resultNode.addChild(maxComboLabel)
        
        
        
        let perfectLabel = SKLabelNode()
        perfectLabel.text = "PERFECT:"
        perfectLabel.fontSize = ratio * 40
        let labelsDifference = (height / 12 * 5 + rankLabel.frame.height / 3.5 - perfectLabel.frame.height) / 4
        perfectLabel.position = CGPointMake(width / 4 * 3 - perfectLabel.frame.width / 2, height / 4 + labelsDifference * 4)
        resultNode.addChild(perfectLabel)
        
        let coolLabel = SKLabelNode()
        coolLabel.text = "COOL:"
        coolLabel.fontSize = ratio * 40
        coolLabel.position = CGPointMake(width / 4 * 3 - coolLabel.frame.width / 2, height / 4 + labelsDifference * 3)
        resultNode.addChild(coolLabel)
        
        let fineLabel = SKLabelNode()
        fineLabel.text = "FINE:"
        fineLabel.fontSize = ratio * 40
        fineLabel.position = CGPointMake(width / 4 * 3 - fineLabel.frame.width / 2, height / 4 + labelsDifference * 2)
        resultNode.addChild(fineLabel)
        
        let badLabel = SKLabelNode()
        badLabel.text = "BAD:"
        badLabel.fontSize = ratio * 40
        badLabel.position = CGPointMake(width / 4 * 3 - badLabel.frame.width / 2, height / 4 + labelsDifference * 1)
        resultNode.addChild(badLabel)
        
        let missLabel = SKLabelNode()
        missLabel.text = "MISS:"
        missLabel.fontSize = ratio * 40
        missLabel.position = CGPointMake(width / 4 * 3 - missLabel.frame.width / 2, height / 4 + labelsDifference * 0)
        resultNode.addChild(missLabel)
        
        let restartButton = SKLabelNode()
        restartButton.text = "RESTART"
        restartButton.fontSize = ratio * 45
        restartButton.position = CGPointMake(width / 24 * 7, height / 6 - restartButton.frame.height / 2)
        restartButton.name = "restartButton"
        resultNode.addChild(restartButton)
        
        let newGameButton = SKLabelNode()
        newGameButton.text = "NEW GAME"
        newGameButton.fontSize = ratio * 45
        newGameButton.position = CGPointMake(width / 24 * 17, height / 6 - newGameButton.frame.height / 2)
        newGameButton.name = "newGameButton"
        resultNode.addChild(newGameButton)
        
        Background.removeFromParent()
        self.addChild(Background)
        
        for var differentJudge: Int = 0; differentJudge < 5; differentJudge++ {
            let JudgeLabel = SKLabelNode()
            JudgeLabel.text = String(differentJudges[differentJudge])
            JudgeLabel.fontSize = ratio * 40
            JudgeLabel.position = CGPointMake(width / 4 * 3 + JudgeLabel.frame.width / 2 + width / 20, (height / 4 + labelsDifference * CGFloat(differentJudge)))
            resultNode.addChild(JudgeLabel)
        }
        self.addChild(resultNode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if node.name != nil {
                switch node.name! {

                case "restartButton" :
                    exporter.player().seekToTime(CMTimeMakeWithSeconds(0, 1))
                    exporter.player().pause()
                    Scene = GameScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "newGameButton" :
                    Scene = ChooseScene(size : CGSizeMake(width, height))
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

