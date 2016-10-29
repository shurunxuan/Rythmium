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
    var touch_particle: [Int : SKEmitterNode] = [:]
    var bestScoreParticle = SKEmitterNode(fileNamed: "BestScoreParticle.sks")!
    

    override func didMove(to view: SKView) {
        Stage = GameStage.result
        
        bestScoreParticle.position = CGPoint(x: width / 2, y: height)
        bestScoreParticle.targetNode = self
        
        Background = backgroundDark.copy() as! SKSpriteNode
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
        rankLabel.position = CGPoint(x: width / 2, y: height / 2)
        rankLabel.alpha = 0
        rankLabel.name = "rankLabel"
        
        let rankLabelCopy = rankLabel.copy() as! SKSpriteNode
        rankLabelCopy.alpha = 0
        rankLabelCopy.name = "rankLabelCopy"
        
        resultNode.addChild(rankLabel)
        resultNode.addChild(rankLabelCopy)
        
        let actionFadeIn = SKAction.fadeIn(withDuration: 0.5)
        let actionScaleTo2x = SKAction.scale(to: ratio * 2, duration: 0.5)
        let actionAppear = SKAction.group([actionFadeIn, actionScaleTo2x])
        actionScaleTo2x.timingMode = SKActionTimingMode.easeIn
        let actionWaitCopyDisappear = SKAction.wait(forDuration: 0.5)
        let actionMoveToPosition = SKAction.move(to: CGPoint(x: width / 24 * 7, y: height / 3 * 2), duration: 0.5)
        actionMoveToPosition.timingMode = SKActionTimingMode.easeOut
        let actionScaleTo1_5x = SKAction.scale(to: ratio * 1.5, duration: 0.5)
        actionScaleTo1_5x.timingMode = SKActionTimingMode.easeOut
        let actionMoveAndScale = SKAction.group([actionMoveToPosition, actionScaleTo1_5x])
        let actionRankLabel = SKAction.sequence([actionAppear, actionWaitCopyDisappear, actionMoveAndScale])
        rankLabel.run(actionRankLabel)
        
        let actionScaleTo10x = SKAction.scale(to: ratio * 10, duration: 0.5)
        actionScaleTo10x.timingMode = SKActionTimingMode.easeOut
        let actionDisappear = SKAction.fadeOut(withDuration: 0.5)
        let actionCopyDisappear = SKAction.group([actionScaleTo10x, actionDisappear])
        let actionRankLabelCopy = SKAction.sequence([actionAppear, actionCopyDisappear, SKAction.removeFromParent()])
        rankLabelCopy.run(actionRankLabelCopy)
        
        if hasBestScore {
            if score > bestScore {
                let bsFile = FileClass()
                bsFile.openFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
                bsFile.write(rank + "\t" + String(score))
                BestScoreSpark()
            }
        } else {
            let bsFile = FileClass()
            bsFile.createFile(String(exporter.songID())+"_"+String(difficultyType.hashValue)+".bs")
            bsFile.write(rank + "\t" + String(score))
            BestScoreSpark()
        }
        
        let scoreLabel = SKLabelNode()
        scoreLabel.text = NSString(format: "SCORE: %08i", score) as String
        scoreLabel.fontName = "SFUIDisplay-Ultralight"
        scoreLabel.fontSize = ratio * 30
        scoreLabel.position = CGPoint(x: width / 24 * 7, y: height / 3)
        scoreLabel.alpha = 0
        resultNode.addChild(scoreLabel)
        scoreLabel.run(SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.fadeIn(withDuration: 0.5)]))
        
        let maxComboLabel = SKLabelNode()
        maxComboLabel.text = NSString(format: "Max Combo: %i", maxCombo) as String
        maxComboLabel.fontName = "SFUIDisplay-Ultralight"
        if fullCombo { maxComboLabel.text = "FULL COMBO"; maxComboLabel.fontName = "SFUIDisplay-Thin" }
        maxComboLabel.fontSize = ratio * 30
        maxComboLabel.position = CGPoint(x: width / 24 * 7, y: height / 4)
        maxComboLabel.alpha = 0
        resultNode.addChild(maxComboLabel)
        maxComboLabel.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.fadeIn(withDuration: 0.5)]))
        
        
        
        let perfectLabel = SKSpriteNode(imageNamed: "rp")
        let scale = 40 * ratio / perfectLabel.frame.height
        perfectLabel.setScale(scale)
        let labelsDifference = (height / 12 * 5 + 289.5 / 3.5 - perfectLabel.frame.height) / 4
        perfectLabel.position = CGPoint(x: width / 4 * 3 - perfectLabel.frame.width / 2, y: height / 4 + labelsDifference * 4 + perfectLabel.frame.height / 2)
        perfectLabel.alpha = 0
        resultNode.addChild(perfectLabel)
        perfectLabel.run(SKAction.sequence([SKAction.wait(forDuration: 2.5), SKAction.fadeIn(withDuration: 0.5)]))
        
        let coolLabel = SKSpriteNode(imageNamed: "rc")
        coolLabel.setScale(scale)
        coolLabel.position = CGPoint(x: width / 4 * 3 - coolLabel.frame.width / 2, y: height / 4 + labelsDifference * 3 + coolLabel.frame.height / 2)
        coolLabel.alpha = 0
        resultNode.addChild(coolLabel)
        coolLabel.run(SKAction.sequence([SKAction.wait(forDuration: 2.7), SKAction.fadeIn(withDuration: 0.5)]))
        
        let fineLabel = SKSpriteNode(imageNamed: "rf")
        fineLabel.setScale(scale)
        fineLabel.position = CGPoint(x: width / 4 * 3 - fineLabel.frame.width / 2, y: height / 4 + labelsDifference * 2 + fineLabel.frame.height / 2)
        fineLabel.alpha = 0
        resultNode.addChild(fineLabel)
        fineLabel.run(SKAction.sequence([SKAction.wait(forDuration: 2.9), SKAction.fadeIn(withDuration: 0.5)]))
        
        let badLabel = SKSpriteNode(imageNamed: "rb")
        badLabel.setScale(scale)
        badLabel.position = CGPoint(x: width / 4 * 3 - badLabel.frame.width / 2, y: height / 4 + labelsDifference * 1 + badLabel.frame.height / 2)
        badLabel.alpha = 0
        resultNode.addChild(badLabel)
        badLabel.run(SKAction.sequence([SKAction.wait(forDuration: 3.1), SKAction.fadeIn(withDuration: 0.5)]))
        
        let missLabel = SKSpriteNode(imageNamed: "rm")
        missLabel.setScale(scale)
        missLabel.position = CGPoint(x: width / 4 * 3 - missLabel.frame.width / 2, y: height / 4 + labelsDifference * 0 + missLabel.frame.height / 2)
        missLabel.alpha = 0
        resultNode.addChild(missLabel)
        missLabel.run(SKAction.sequence([SKAction.wait(forDuration: 3.3), SKAction.fadeIn(withDuration: 0.5)]))
        
        let restartButton = SKLabelNode()
        restartButton.text = "RESTART"
        restartButton.fontName = "SFUIDisplay-Ultralight"
        restartButton.fontSize = ratio * 45
        restartButton.position = CGPoint(x: width / 16 + restartButton.frame.width / 2, y: height / 16)
        restartButton.name = "restartButton"
        restartButton.alpha = 0
        resultNode.addChild(restartButton)
        restartButton.run(SKAction.sequence([SKAction.wait(forDuration: 3.8), SKAction.fadeIn(withDuration: 0.5)]))
        
        let newGameButton = SKLabelNode()
        newGameButton.text = "NEW GAME"
        newGameButton.fontName = "SFUIDisplay-Ultralight"
        newGameButton.fontSize = ratio * 45
        newGameButton.position = CGPoint(x: width / 16 * 15 - newGameButton.frame.width / 2, y: height / 16)
        newGameButton.name = "newGameButton"
        newGameButton.alpha = 0
        resultNode.addChild(newGameButton)
        newGameButton.run(SKAction.sequence([SKAction.wait(forDuration: 3.8), SKAction.fadeIn(withDuration: 0.5)]))
        
        Background.removeFromParent()
        self.addChild(Background)
        
        let judges = ["p", "c", "f", "b", "m"]
        let judgesLabel = [perfectLabel, coolLabel, fineLabel, badLabel, missLabel]
        for differentJudge: Int in 0 ..< 5 {
            let JudgeLabel = SKNode()
            let str = String(differentJudges[differentJudge])
            var maxWidth : CGFloat = 0
            var numbers = [SKSpriteNode]()
            for i in 0 ..< str.characters.count {
                let number = SKSpriteNode(imageNamed: judges[4 - differentJudge] + String(str[i]))
                number.setScale(scale)
                if number.frame.width > maxWidth { maxWidth = number.frame.width }
                numbers.append(number)
            }
            for i in 0 ..< numbers.count {
                numbers[i].position = CGPoint(x: CGFloat(i) * maxWidth, y: 0)
                JudgeLabel.addChild(numbers[i])
            }
            JudgeLabel.position = CGPoint(x: width / 4 * 3 + JudgeLabel.frame.width / 2 + width / 20, y: judgesLabel[4 - differentJudge].position.y)
            JudgeLabel.alpha = 0
            resultNode.addChild(JudgeLabel)
            JudgeLabel.run(SKAction.sequence([SKAction.wait(forDuration: 2.5 + 0.2 * Double(4 - differentJudge)), SKAction.fadeIn(withDuration: 0.5)]))
        }
        self.addChild(resultNode)
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

            for node in resultNode.children {
                node.removeAllActions()
                if node.name == "rankLabel" {
                    node.position = CGPoint(x: width / 24 * 7, y: height / 3 * 2)
                    node.setScale(1.5 * ratio)
                } else if node.name == "rankLabelCopy" {
                    node.removeFromParent()
                }
                node.alpha = 1
            }
            
            if node.name != nil {
                switch node.name! {

                case "restartButton" :
                    exporter.player().seek(to: CMTimeMakeWithSeconds(0, 1))
                    exporter.player().pause()
                    restarted = true
                    Scene = ConfirmScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case "newGameButton" :
                    restarted = false
                    Scene = ChooseScene(size : CGSize(width: width, height: height))
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
    
    func BestScoreSpark() {
        srand48(Int(time(nil)))
        for i: Int in 0 ..< 6 {
            let particle = bestScoreParticle.copy() as! SKEmitterNode
            particle.position = CGPoint(x: CGFloat(drand48()) * width, y: CGFloat(drand48()) * height / 2 + height / 2)
            self.addChild(particle)
            particle.particleBirthRate = 0
            particle.run(SKAction.sequence([SKAction.wait(forDuration: 0.5 * Double(i + 1)), SKAction.run({particle.particleBirthRate = 2000}), SKAction.wait(forDuration: 0.2), SKAction.run({particle.particleBirthRate = 0}), SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
        }
    }
}

