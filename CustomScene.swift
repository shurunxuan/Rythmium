//
//  CustomScene.swift
//  Rythmium
//
//  Created by 舒润萱 on 15/11/30.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

class CustomScene: SKScene {
    
    
    var Init = true
    
    var gameNode = GameNode()
    var countDownLabel = SKLabelNode()
    var titleLabel = SKLabelNode()
    var artistLabel = SKLabelNode()
    var scoreLabel = SKLabelNode(text: "SCORE: 00000000")
    
    var MSSFile = FileClass()
    
    var timeList = [[Double](), [Double]()]
    let Position = [CGPointMake(width * 3 / 4, height * 3 / 4), CGPointMake(width / 4, height * 3 / 4), CGPointMake(width / 4, height / 4), CGPointMake(width * 3 / 4, height / 4)]
    
    //var staticNodes = [Note]()
    var staticNodes = [SKSpriteNode]()
    //var staticNodes = [MYStaticNode]()
    
    var startTime: Double = 0.0
    
    
    var playing = false
    
    var CurrentTime: Double = 0.0
    
    var pauseButton = SKSpriteNode()
    static var pause = false
    static var pauseInit = false
    var pauseBackground = SKSpriteNode()
    var Background = SKSpriteNode()
    
    let AppearDelay = 1.0
    
    var appearAction = SKAction()
    
    var touch_particle: [Int : SKEmitterNode] = [:]
    
    var centerMaskCircle = SKShapeNode(circleOfRadius: 60)
    var luMaskCircle = SKShapeNode(circleOfRadius: 32)
    var ruMaskCircle = SKShapeNode(circleOfRadius: 32)
    var ldMaskCircle = SKShapeNode(circleOfRadius: 32)
    var rdMaskCircle = SKShapeNode(circleOfRadius: 32)
    
    var centerMask = SKCropNode()
    
    override func didMoveToView(view: SKView) {
        Stage = GameStage.Game
        
        self.view?.multipleTouchEnabled = true
        
        Background = background.copy() as! SKSpriteNode
        Background.alpha = 1
        self.addChild(Background)

        
        CurrentTime = 0.0
        
        
        playing = false
        
        score = 0
        totalScore = 0
        combo = 0
        maxCombo = 0
        fullCombo = true
        
        scoreLabel.text = "SCORE: 00000000"
        
        //appearAction = [SKAction.group([SKAction.moveTo(CGPointMake(width * 3 / 4, height * 3 / 4), duration: AppearDelay), SKAction.scaleTo(1.0, duration: AppearDelay), SKAction.fadeAlphaTo(0.8, duration: 0.5)]),
          //  SKAction.group([SKAction.moveTo(CGPointMake(width / 4, height * 3 / 4), duration: AppearDelay), SKAction.scaleTo(1.0, duration: AppearDelay), SKAction.fadeAlphaTo(0.8, duration: 0.5)]),
            //SKAction.group([SKAction.moveTo(CGPointMake(width / 4, height / 4), duration: AppearDelay), SKAction.scaleTo(1.0, duration: AppearDelay), SKAction.fadeAlphaTo(0.8, duration: 0.5)]),
            //SKAction.group([SKAction.moveTo(CGPointMake(width * 3 / 4, height / 4), duration: AppearDelay), SKAction.scaleTo(1.0, duration: AppearDelay), SKAction.fadeAlphaTo(0.8, duration: 0.5)])]
        
        appearAction = SKAction.group([SKAction.moveTo(CGPointMake(width / 2, height / 2), duration: AppearDelay), SKAction.fadeOutWithDuration(AppearDelay), SKAction.scaleTo(0.5, duration: AppearDelay)])
        
        staticNodes = [SKSpriteNode(imageNamed: "alpha"), SKSpriteNode(imageNamed: "alpha"), SKSpriteNode(imageNamed: "alpha"), SKSpriteNode(imageNamed: "alpha")]
        //let ruRect = CGRectMake(width / 2, height / 2, width / 2, height / 2)
        //let luRect = CGRectMake(0, height / 2, width / 2, height / 2)
        //let ldRect = CGRectMake(0, 0, width / 2, height / 2)
        //let rdRect = CGRectMake(width / 2, 0, width / 2, height / 2)
        
        //staticNodes = [MYStaticNode(rect: ruRect), MYStaticNode(rect: luRect), MYStaticNode(rect: ldRect), MYStaticNode(rect: rdRect)]
        
        centerMaskCircle.position = CGPointMake(width / 2, height / 2)
        ruMaskCircle.position = CGPointMake(width / 4 * 3, height / 4 * 3)
        luMaskCircle.position = CGPointMake(width / 4, height / 4 * 3)
        ldMaskCircle.position = CGPointMake(width / 4, height / 4)
        rdMaskCircle.position = CGPointMake(width / 4 * 3, height / 4)
        
        centerMaskCircle.strokeColor = SKColor.clearColor()
        ruMaskCircle.strokeColor = SKColor.clearColor()
        luMaskCircle.strokeColor = SKColor.clearColor()
        ldMaskCircle.strokeColor = SKColor.clearColor()
        rdMaskCircle.strokeColor = SKColor.clearColor()
        
        centerMaskCircle.fillColor = SKColor.whiteColor()
        ruMaskCircle.fillColor = SKColor.whiteColor()
        luMaskCircle.fillColor = SKColor.whiteColor()
        ldMaskCircle.fillColor = SKColor.whiteColor()
        rdMaskCircle.fillColor = SKColor.whiteColor()
        
        centerMask.maskNode = SKNode()
        centerMask.maskNode!.addChild(centerMaskCircle)
        centerMask.maskNode!.addChild(ruMaskCircle)
        centerMask.maskNode!.addChild(luMaskCircle)
        centerMask.maskNode!.addChild(ldMaskCircle)
        centerMask.maskNode!.addChild(rdMaskCircle)
        
        centerMask.addChild(Background.copy() as! SKSpriteNode)
        
        centerMask.zPosition = -500
        
        gameNode.addChild(centerMask)
        
        
        for node in staticNodes {
            node.size = CGSizeMake(width / 2, height / 2)
            node.zPosition = -501
        }
        
        staticNodes[0].position = CGPointMake(width - staticNodes[0].frame.width / 2, height - staticNodes[0].frame.height / 2)
        staticNodes[1].position = CGPointMake(staticNodes[1].frame.width / 2, height - staticNodes[1].frame.height / 2)
        staticNodes[2].position = CGPointMake(staticNodes[2].frame.width / 2, staticNodes[2].frame.height / 2)
        staticNodes[3].position = CGPointMake(width - staticNodes[3].frame.width / 2, staticNodes[3].frame.height / 2)
        
        scoreLabel.fontName = "SFUIDisplay-Ultralight"
        scoreLabel.fontSize = ratio * 20
        scoreLabel.position = CGPointMake(width - scoreLabel.frame.width * 0.6, height - scoreLabel.frame.height * 1.2)
        scoreLabel.alpha = 0
        scoreLabel.text = "SCORE: 00000000"
        
        
        countDownLabel.text = "3"
        countDownLabel.fontName = "SFUIDisplay-Ultralight"
        countDownLabel.fontSize = ratio * 60
        countDownLabel.position = CGPointMake(width / 2, height / 2 - countDownLabel.frame.height / 2)
        
        gameNode.alpha = 1
        gameNode.addChild(countDownLabel)
        gameNode.addChild(titleLabel)
        gameNode.addChild(artistLabel)
        gameNode.addChild(scoreLabel)
        
        
        
        pauseButton = SKSpriteNode(imageNamed: "pauseButton")
        pauseButton.position = CGPointMake(pauseButton.frame.width * 0.55, height - pauseButton.frame.height * 0.55)
        pauseButton.name = "pauseButton"
        pauseButton.alpha = 0
        pauseButton.zPosition = 1000
        
        
        titleLabel.text = exporter.songTitle()
        artistLabel.text = exporter.songArtist()
        titleLabel.fontSize = ratio * 60
        artistLabel.fontSize = ratio * 60
        titleLabel.fontName = "SFUIDisplay-Ultralight"
        artistLabel.fontName = "SFUIDisplay-Ultralight"
        while titleLabel.frame.width > width * 0.9 || artistLabel.frame.width > width * 0.9 {
            titleLabel.fontSize--
            artistLabel.fontSize--
        }
        titleLabel.position = CGPointMake(width + titleLabel.frame.width / 2, height / 2 + countDownLabel.frame.height + titleLabel.frame.height * 0.05)
        artistLabel.position = CGPointMake(-artistLabel.frame.width / 2, height / 2 - countDownLabel.frame.height - artistLabel.frame.height * 1.05)

        
        
        for var note: Int = 0; note < 4; ++note {
            staticNodes[note].alpha = 0
            gameNode.addChild(staticNodes[note])
            staticNodes[note].runAction(SKAction.sequence([SKAction.waitForDuration(3), SKAction.fadeAlphaTo(0.05, duration: 0.5)]))
            
        }
        scoreLabel.runAction(SKAction.sequence([SKAction.waitForDuration(3), staticNodesAppearAction]))
        
        self.addChild(gameNode)
        
        
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
                switch node.name! {
                case "pauseButton" :
                    GameScene.pause = true
                    GameScene.pauseInit = true
                case "Resume" :
                    GameScene.pause = false
                    GameScene.pauseInit = true
                    pauseBackground.removeAllChildren()
                    pauseBackground.removeFromParent()
                    self.addChild(countDownLabel)
                case "Restart" :
                    exporter.player().seekToTime(CMTimeMakeWithSeconds(0, 1))
                    GameScene.pause = false
                    GameScene.pauseInit = false
                    self.gameNode.paused = false
                    self.removeAllChildren()
                    gameNode.removeAllChildren()
                    Background.removeFromParent()
                    Scene = GameScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case "Exit" :
                    self.gameNode.paused = false
                    for nodes in gameNode.children {
                        let node = nodes as SKNode
                        node.runAction(staticNodesDisappearAction)
                    }
                    gameNode.runAction(staticNodesDisappearAction)
                    for nodes in self.children {
                        let node = nodes as SKNode
                        node.runAction(staticNodesDisappearAction)
                    }
                    GameScene.pause = false
                    GameScene.pauseInit = false
                    Scene = StartUpScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                default:
                    break
                }
            } else {
                
                var pos: Int = 4
                if location.x >= width / 2 && location.y >= height / 2 { pos = 0 }
                if location.x <= width / 2 && location.y >= height / 2 { pos = 1 }
                if location.x <= width / 2 && location.y <= height / 2 { pos = 2 }
                if location.x >= width / 2 && location.y <= height / 2 { pos = 3 }
                


                        let displayingNote = Note(time: CurrentTime, center: Position[pos], radius: 60 * ratio)
                displayingNote.setScale(1)
                displayingNote.alpha = 0.8
                        gameNode.addChild(displayingNote)
                        staticNodes[pos].removeAllActions()
                        staticNodes[pos].alpha = 0.4

                        staticNodes[pos].runAction(SKAction.colorizeWithColor(UIColor.init(red: 202.0 / 255.0, green: 202.0 / 255.0, blue: 202.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                        
                        
                        let colorizeAction1 = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1, duration: 0.5)
                        colorizeAction1.timingMode = SKActionTimingMode.EaseIn
                        let colorizeAction2 = SKAction.fadeAlphaTo(0.05, duration: 0.5)
                        colorizeAction2.timingMode = SKActionTimingMode.EaseIn
                        staticNodes[pos].runAction(SKAction.group([colorizeAction1, colorizeAction2]))
                        displayingNote.runAction(appearAction)
                        
                        timeList[0].append(CurrentTime)
                        timeList[1].append(Double(pos))
                    
                
                
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if Init { startTime = Double(currentTime) + 3.9; Init = false }
        if !playing {
            CurrentTime = Double(currentTime) - startTime
            if Int(CurrentTime) < 0 {
                countDownLabel.text = String(-Int(CurrentTime))
                let t0 = CGFloat(CurrentTime + 3.5)
                let t1 = CGFloat(CurrentTime + 3.5)
                let X_A = CGFloat(1)
                let f0 = (t0-X_A)*(t0-X_A)*(t0-X_A)
                let f1 = (X_A*X_A*X_A)
                let f00 = f0 / f1
                let f01 = (width + titleLabel.frame.width) / 2
                let f10 = (t1-X_A)*(t1-X_A)*(t1-X_A)/(X_A*X_A*X_A)
                let f11 = (width + artistLabel.frame.width) / 2
                titleLabel.position.x = width + titleLabel.frame.width / 2 - (f00+1) * f01
                artistLabel.position.x = -artistLabel.frame.width / 2 + (f10+1) * f11
            }
            if Int(CurrentTime) == 0 {
                countDownLabel.text = "START!"
                titleLabel.removeFromParent()
                artistLabel.removeFromParent()
            }
            if CurrentTime > 0 {
                exporter.play()
                playing = true
                gameNode.addChild(pauseButton)
                pauseButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                countDownLabel.removeFromParent()
                
            }
        } else {
            
            if GameScene.pause {
                if GameScene.pauseInit {
                    
                    exporter.player().pause()
                    
                    self.gameNode.paused = true
                    gameNode.setStayPaused()
                    let pauseLabel = SKLabelNode(text: "PAUSED")
                    pauseLabel.fontSize = ratio * 70
                    pauseLabel.fontName = "SFUIDisplay-Ultralight"
                    pauseLabel.position = CGPointMake(width / 2, height * 0.65 - pauseLabel.frame.height / 2)
                    pauseLabel.zPosition = 300
                    pauseBackground.addChild(pauseLabel)
                    
                    
                    let bgcopy = Background.copy() as! SKNode
                    bgcopy.zPosition = 299
                    pauseBackground.addChild(bgcopy)
                    
                    
                    let resumeLabel = SKLabelNode(text: "Resume")
                    resumeLabel.fontSize = ratio * 45
                    resumeLabel.fontName = "SFUIDisplay-Ultralight"
                    resumeLabel.position = CGPointMake(width / 3 - resumeLabel.frame.width / 2, height / 2 - pauseLabel.frame.height * 0.65 - resumeLabel.frame.height)
                    resumeLabel.zPosition = 300
                    resumeLabel.name = "Resume"
                    pauseBackground.addChild(resumeLabel)
                    
                    
                    let restartLabel = SKLabelNode(text: "Restart")
                    restartLabel.fontSize = ratio * 45
                    restartLabel.fontName = "SFUIDisplay-Ultralight"
                    restartLabel.position = CGPointMake(width / 2, height / 2 - pauseLabel.frame.height * 0.65 - restartLabel.frame.height)
                    restartLabel.zPosition = 300
                    restartLabel.name = "Restart"
                    pauseBackground.addChild(restartLabel)
                    
                    
                    let exitLabel = SKLabelNode(text: "Exit")
                    exitLabel.fontSize = ratio * 45
                    exitLabel.fontName = "SFUIDisplay-Ultralight"
                    exitLabel.position = CGPointMake(width / 3 * 2 + restartLabel.frame.width / 2, height / 2 - pauseLabel.frame.height * 0.65 - exitLabel.frame.height)
                    exitLabel.zPosition = 300
                    exitLabel.name = "Exit"
                    pauseBackground.addChild(exitLabel)
                    
                    pauseBackground.zPosition = 1001
                    
                    pauseBackground.alpha = 1
                    
                    pauseButton.alpha = 0
                    self.addChild(pauseBackground)
                    GameScene.pauseInit = false
                }
                startTime = Double(currentTime) + 4
            } else {
                if GameScene.pauseInit {
                    CurrentTime = Double(currentTime) - startTime
                    if Int(CurrentTime) < 0 {
                        countDownLabel.text = String(-Int(CurrentTime))
                    }
                    if Int(CurrentTime) == 0 {
                        countDownLabel.text = "START!"
                    }
                    if CurrentTime > 0 {
                        exporter.play()
                        countDownLabel.removeFromParent()
                        pauseButton.runAction(SKAction.fadeAlphaTo(1, duration: 0.5))
                        self.gameNode.unsetStayPaused()
                        self.gameNode.paused = false
                        GameScene.pauseInit = false
                    }
                    
                    
                } else {
                    CurrentTime = CMTimeGetSeconds(exporter.player().currentTime())
                    var i = Int(CurrentTime * 44100.0)
                    if i < 0 { i = 0 }
                    
                    
                    
                    
                    
                    // debug only
                    //if CurrentTime > 1 {
                    //    for var differentJudge: Int = 0; differentJudge < 5; differentJudge++ {
                    //        differentJudges[differentJudge] = differentJudge + 1000
                    //    }
                    //    Scene = ResultScene(size : CGSizeMake(width, height))
                    //    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                    //}
                    
                    // end of game
                    if CurrentTime > Double(exporter.Song().playbackDuration) {

                        if !FileClass.isExist(String(exporter.songID())+"_custom.mss")
                        { MSSFile.CreateFile(String(exporter.songID())+"_custom.mss"); MSSFile.OpenFile(String(exporter.songID())+"_custom.mss") }
                        else
                        { MSSFile.OpenFile(String(exporter.songID())+"_custom.mss"); MSSFile.Write("") }
                        
                        var WriteString = ""
                        for var i: Int = 0; i < timeList[0].count; ++i {
                            WriteString += String(timeList[0][i]) + "\t" + String(Int(timeList[1][i])) + "\n"
                        }
                        MSSFile.Write(WriteString)
                        
                        
                            Scene = ConfirmScene(size : CGSizeMake(width, height))
                            View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                        
                        
                    }
                    
                    
                }
            }
        }
    }
    
    
    
    override func didFinishUpdate() {
        /* Put the code here after each frame is rendered. */
        
    }
}
