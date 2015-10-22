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
        rankLabel.setScale(ratio * 5)
        rankLabel.position = CGPointMake(width / 2, height / 2)
        rankLabel.alpha = 0
        rankLabel.name = "rankLabel"
        
        let rankLabelCopy = rankLabel.copy() as! SKSpriteNode
        rankLabelCopy.alpha = 0
        rankLabelCopy.name = "rankLabelCopy"
        
        resultNode.addChild(rankLabel)
        resultNode.addChild(rankLabelCopy)
        
        let actionFadeIn = SKAction.fadeInWithDuration(0.5)
        let actionScaleTo2x = SKAction.scaleTo(ratio * 2, duration: 0.5)
        let actionAppear = SKAction.group([actionFadeIn, actionScaleTo2x])
        actionScaleTo2x.timingMode = SKActionTimingMode.EaseIn
        let actionWaitCopyDisappear = SKAction.waitForDuration(0.5)
        let actionMoveToPosition = SKAction.moveTo(CGPointMake(width / 24 * 7, height / 3 * 2), duration: 0.5)
        actionMoveToPosition.timingMode = SKActionTimingMode.EaseOut
        let actionScaleTo1_5x = SKAction.scaleTo(ratio * 1.5, duration: 0.5)
        actionScaleTo1_5x.timingMode = SKActionTimingMode.EaseOut
        let actionMoveAndScale = SKAction.group([actionMoveToPosition, actionScaleTo1_5x])
        let actionRankLabel = SKAction.sequence([actionAppear, actionWaitCopyDisappear, actionMoveAndScale])
        rankLabel.runAction(actionRankLabel)
        
        let actionScaleTo10x = SKAction.scaleTo(ratio * 10, duration: 0.5)
        actionScaleTo10x.timingMode = SKActionTimingMode.EaseOut
        let actionDisappear = SKAction.fadeOutWithDuration(0.5)
        let actionCopyDisappear = SKAction.group([actionScaleTo10x, actionDisappear])
        let actionRankLabelCopy = SKAction.sequence([actionAppear, actionCopyDisappear, SKAction.removeFromParent()])
        rankLabelCopy.runAction(actionRankLabelCopy)
        
        if hasBestScore {
            if score > bestScore {
                let bsFile = FileClass()
                bsFile.OpenFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                bsFile.Write(rank + "\t" + String(score))
                // add bestScore animation
            }
        } else {
            let bsFile = FileClass()
            bsFile.CreateFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
            bsFile.Write(rank + "\t" + String(score))
            // add bestScore animation
        }
        
        let scoreLabel = SKLabelNode()
        scoreLabel.text = NSString(format: "SCORE: %08i", score) as String
        scoreLabel.fontSize = ratio * 30
        scoreLabel.position = CGPointMake(width / 24 * 7, height / 3)
        scoreLabel.alpha = 0
        resultNode.addChild(scoreLabel)
        scoreLabel.runAction(SKAction.sequence([SKAction.waitForDuration(1.5), SKAction.fadeInWithDuration(0.5)]))
        
        let maxComboLabel = SKLabelNode()
        maxComboLabel.text = NSString(format: "Max Combo: %i", maxCombo) as String
        if fullCombo { maxComboLabel.text = "FULL COMBO"; maxComboLabel.fontName = "Helvetica Neue Light" }
        maxComboLabel.fontSize = ratio * 30
        maxComboLabel.position = CGPointMake(width / 24 * 7, height / 4)
        maxComboLabel.alpha = 0
        resultNode.addChild(maxComboLabel)
        maxComboLabel.runAction(SKAction.sequence([SKAction.waitForDuration(2), SKAction.fadeInWithDuration(0.5)]))
        
        
        
        let perfectLabel = SKSpriteNode(imageNamed: "rp")
        let scale = 40 * ratio / perfectLabel.frame.height
        perfectLabel.setScale(scale)
        let labelsDifference = (height / 12 * 5 + 289.5 / 3.5 - perfectLabel.frame.height) / 4
        perfectLabel.position = CGPointMake(width / 4 * 3 - perfectLabel.frame.width / 2, height / 4 + labelsDifference * 4 + perfectLabel.frame.height / 2)
        perfectLabel.alpha = 0
        resultNode.addChild(perfectLabel)
        perfectLabel.runAction(SKAction.sequence([SKAction.waitForDuration(2.5), SKAction.fadeInWithDuration(0.5)]))
        
        let coolLabel = SKSpriteNode(imageNamed: "rc")
        coolLabel.setScale(scale)
        coolLabel.position = CGPointMake(width / 4 * 3 - coolLabel.frame.width / 2, height / 4 + labelsDifference * 3 + coolLabel.frame.height / 2)
        coolLabel.alpha = 0
        resultNode.addChild(coolLabel)
        coolLabel.runAction(SKAction.sequence([SKAction.waitForDuration(2.7), SKAction.fadeInWithDuration(0.5)]))
        
        let fineLabel = SKSpriteNode(imageNamed: "rf")
        fineLabel.setScale(scale)
        fineLabel.position = CGPointMake(width / 4 * 3 - fineLabel.frame.width / 2, height / 4 + labelsDifference * 2 + fineLabel.frame.height / 2)
        fineLabel.alpha = 0
        resultNode.addChild(fineLabel)
        fineLabel.runAction(SKAction.sequence([SKAction.waitForDuration(2.9), SKAction.fadeInWithDuration(0.5)]))
        
        let badLabel = SKSpriteNode(imageNamed: "rb")
        badLabel.setScale(scale)
        badLabel.position = CGPointMake(width / 4 * 3 - badLabel.frame.width / 2, height / 4 + labelsDifference * 1 + badLabel.frame.height / 2)
        badLabel.alpha = 0
        resultNode.addChild(badLabel)
        badLabel.runAction(SKAction.sequence([SKAction.waitForDuration(3.1), SKAction.fadeInWithDuration(0.5)]))
        
        let missLabel = SKSpriteNode(imageNamed: "rm")
        missLabel.setScale(scale)
        missLabel.position = CGPointMake(width / 4 * 3 - missLabel.frame.width / 2, height / 4 + labelsDifference * 0 + missLabel.frame.height / 2)
        missLabel.alpha = 0
        resultNode.addChild(missLabel)
        missLabel.runAction(SKAction.sequence([SKAction.waitForDuration(3.3), SKAction.fadeInWithDuration(0.5)]))
        
        let restartButton = SKLabelNode()
        restartButton.text = "RESTART"
        restartButton.fontSize = ratio * 45
        restartButton.position = CGPointMake(width / 16 + restartButton.frame.width / 2, height / 16)
        restartButton.name = "restartButton"
        restartButton.alpha = 0
        resultNode.addChild(restartButton)
        restartButton.runAction(SKAction.sequence([SKAction.waitForDuration(3.8), SKAction.fadeInWithDuration(0.5)]))
        
        let newGameButton = SKLabelNode()
        newGameButton.text = "NEW GAME"
        newGameButton.fontSize = ratio * 45
        newGameButton.position = CGPointMake(width / 16 * 15 - newGameButton.frame.width / 2, height / 16)
        newGameButton.name = "newGameButton"
        newGameButton.alpha = 0
        resultNode.addChild(newGameButton)
        newGameButton.runAction(SKAction.sequence([SKAction.waitForDuration(3.8), SKAction.fadeInWithDuration(0.5)]))
        
        Background.removeFromParent()
        self.addChild(Background)
        
        let judges = ["p", "c", "f", "b", "m"]
        let judgesLabel = [perfectLabel, coolLabel, fineLabel, badLabel, missLabel]
        for var differentJudge: Int = 0; differentJudge < 5; differentJudge++ {
            let JudgeLabel = SKNode()
            let str = String(differentJudges[differentJudge])
            for var i = 0; i < str.characters.count; ++i {
                let number = SKSpriteNode(imageNamed: judges[4 - differentJudge] + String(str[i]))
                number.setScale(scale)
                number.position = CGPointMake(CGFloat(i) * number.frame.width, 0)
                JudgeLabel.addChild(number)
            }
            JudgeLabel.position = CGPointMake(width / 4 * 3 + JudgeLabel.frame.width / 2 + width / 20, judgesLabel[4 - differentJudge].position.y)
            JudgeLabel.alpha = 0
            resultNode.addChild(JudgeLabel)
            JudgeLabel.runAction(SKAction.sequence([SKAction.waitForDuration(2.5 + 0.2 * Double(4 - differentJudge)), SKAction.fadeInWithDuration(0.5)]))
        }
        self.addChild(resultNode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            for node in resultNode.children {
                node.removeAllActions()
                if node.name == "rankLabel" {
                    node.position = CGPointMake(width / 24 * 7, height / 3 * 2)
                    node.setScale(1.5 * ratio)
                } else if node.name == "rankLabelCopy" {
                    node.removeFromParent()
                }
                node.alpha = 1
            }
            
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

