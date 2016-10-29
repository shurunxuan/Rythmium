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
    let Position = [CGPoint(x: width * 3 / 4, y: height * 3 / 4), CGPoint(x: width / 4, y: height * 3 / 4), CGPoint(x: width / 4, y: height / 4), CGPoint(x: width * 3 / 4, y: height / 4)]
    
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
    
    override func didMove(to view: SKView) {
        Stage = GameStage.game
        
        self.view?.isMultipleTouchEnabled = true
        
        Background = backgroundDark.copy() as! SKSpriteNode
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
        
        appearAction = SKAction.group([SKAction.move(to: CGPoint(x: width / 2, y: height / 2), duration: AppearDelay), SKAction.fadeOut(withDuration: AppearDelay), SKAction.scale(to: 0.5, duration: AppearDelay)])
        
        staticNodes = [SKSpriteNode(imageNamed: "alpha"), SKSpriteNode(imageNamed: "alpha"), SKSpriteNode(imageNamed: "alpha"), SKSpriteNode(imageNamed: "alpha")]
        //let ruRect = CGRectMake(width / 2, height / 2, width / 2, height / 2)
        //let luRect = CGRectMake(0, height / 2, width / 2, height / 2)
        //let ldRect = CGRectMake(0, 0, width / 2, height / 2)
        //let rdRect = CGRectMake(width / 2, 0, width / 2, height / 2)
        
        //staticNodes = [MYStaticNode(rect: ruRect), MYStaticNode(rect: luRect), MYStaticNode(rect: ldRect), MYStaticNode(rect: rdRect)]
        
        centerMaskCircle.position = CGPoint(x: width / 2, y: height / 2)
        ruMaskCircle.position = CGPoint(x: width / 4 * 3, y: height / 4 * 3)
        luMaskCircle.position = CGPoint(x: width / 4, y: height / 4 * 3)
        ldMaskCircle.position = CGPoint(x: width / 4, y: height / 4)
        rdMaskCircle.position = CGPoint(x: width / 4 * 3, y: height / 4)
        
        centerMaskCircle.strokeColor = SKColor.clear
        ruMaskCircle.strokeColor = SKColor.clear
        luMaskCircle.strokeColor = SKColor.clear
        ldMaskCircle.strokeColor = SKColor.clear
        rdMaskCircle.strokeColor = SKColor.clear
        
        centerMaskCircle.fillColor = SKColor.white
        ruMaskCircle.fillColor = SKColor.white
        luMaskCircle.fillColor = SKColor.white
        ldMaskCircle.fillColor = SKColor.white
        rdMaskCircle.fillColor = SKColor.white
        
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
            node.size = CGSize(width: width / 2, height: height / 2)
            node.zPosition = -501
        }
        
        staticNodes[0].position = CGPoint(x: width - staticNodes[0].frame.width / 2, y: height - staticNodes[0].frame.height / 2)
        staticNodes[1].position = CGPoint(x: staticNodes[1].frame.width / 2, y: height - staticNodes[1].frame.height / 2)
        staticNodes[2].position = CGPoint(x: staticNodes[2].frame.width / 2, y: staticNodes[2].frame.height / 2)
        staticNodes[3].position = CGPoint(x: width - staticNodes[3].frame.width / 2, y: staticNodes[3].frame.height / 2)
        
        scoreLabel.fontName = "SFUIDisplay-Ultralight"
        scoreLabel.fontSize = ratio * 20
        scoreLabel.position = CGPoint(x: width - scoreLabel.frame.width * 0.6, y: height - scoreLabel.frame.height * 1.2)
        scoreLabel.alpha = 0
        scoreLabel.text = "SCORE: 00000000"
        
        
        countDownLabel.text = "3"
        countDownLabel.fontName = "SFUIDisplay-Ultralight"
        countDownLabel.fontSize = ratio * 60
        countDownLabel.position = CGPoint(x: width / 2, y: height / 2 - countDownLabel.frame.height / 2)
        
        gameNode.alpha = 1
        gameNode.addChild(countDownLabel)
        gameNode.addChild(titleLabel)
        gameNode.addChild(artistLabel)
        gameNode.addChild(scoreLabel)
        
        
        
        pauseButton = SKSpriteNode(imageNamed: "pauseButton")
        pauseButton.position = CGPoint(x: pauseButton.frame.width * 0.55, y: height - pauseButton.frame.height * 0.55)
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
            titleLabel.fontSize -= 1
            artistLabel.fontSize -= 1
        }
        titleLabel.position = CGPoint(x: width + titleLabel.frame.width / 2, y: height / 2 + countDownLabel.frame.height + titleLabel.frame.height * 0.05)
        artistLabel.position = CGPoint(x: -artistLabel.frame.width / 2, y: height / 2 - countDownLabel.frame.height - artistLabel.frame.height * 1.05)

        
        
        for note: Int in 0 ..< 4 {
            staticNodes[note].alpha = 0
            gameNode.addChild(staticNodes[note])
            staticNodes[note].run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.fadeAlpha(to: 0.05, duration: 0.5)]))
            
        }
        scoreLabel.run(SKAction.sequence([SKAction.wait(forDuration: 3), staticNodesAppearAction]))
        
        self.addChild(gameNode)
        
        
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
                    exporter.player().seek(to: CMTimeMakeWithSeconds(0, 1))
                    GameScene.pause = false
                    GameScene.pauseInit = false
                    self.gameNode.isPaused = false
                    self.removeAllChildren()
                    gameNode.removeAllChildren()
                    Background.removeFromParent()
                    Scene = GameScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case "Exit" :
                    self.gameNode.isPaused = false
                    for nodes in gameNode.children {
                        let node = nodes as SKNode
                        node.run(staticNodesDisappearAction)
                    }
                    gameNode.run(staticNodesDisappearAction)
                    for nodes in self.children {
                        let node = nodes as SKNode
                        node.run(staticNodesDisappearAction)
                    }
                    GameScene.pause = false
                    GameScene.pauseInit = false
                    Scene = StartUpScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
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

                        staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 202.0 / 255.0, green: 202.0 / 255.0, blue: 202.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                        
                        
                        let colorizeAction1 = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.5)
                        colorizeAction1.timingMode = SKActionTimingMode.easeIn
                        let colorizeAction2 = SKAction.fadeAlpha(to: 0.05, duration: 0.5)
                        colorizeAction2.timingMode = SKActionTimingMode.easeIn
                        staticNodes[pos].run(SKAction.group([colorizeAction1, colorizeAction2]))
                        displayingNote.run(appearAction)
                        
                        timeList[0].append(CurrentTime)
                        timeList[1].append(Double(pos))
                    
                
                
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
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
                pauseButton.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                countDownLabel.removeFromParent()
                
            }
        } else {
            
            if GameScene.pause {
                if GameScene.pauseInit {
                    
                    exporter.player().pause()
                    
                    self.gameNode.isPaused = true
                    gameNode.setStayPaused()
                    let pauseLabel = SKLabelNode(text: "PAUSED")
                    pauseLabel.fontSize = ratio * 70
                    pauseLabel.fontName = "SFUIDisplay-Ultralight"
                    pauseLabel.position = CGPoint(x: width / 2, y: height * 0.65 - pauseLabel.frame.height / 2)
                    pauseLabel.zPosition = 300
                    pauseBackground.addChild(pauseLabel)
                    
                    
                    let bgcopy = Background.copy() as! SKNode
                    bgcopy.zPosition = 299
                    pauseBackground.addChild(bgcopy)
                    
                    
                    let resumeLabel = SKLabelNode(text: "Resume")
                    resumeLabel.fontSize = ratio * 45
                    resumeLabel.fontName = "SFUIDisplay-Ultralight"
                    resumeLabel.position = CGPoint(x: width / 3 - resumeLabel.frame.width / 2, y: height / 2 - pauseLabel.frame.height * 0.65 - resumeLabel.frame.height)
                    resumeLabel.zPosition = 300
                    resumeLabel.name = "Resume"
                    pauseBackground.addChild(resumeLabel)
                    
                    
                    let restartLabel = SKLabelNode(text: "Restart")
                    restartLabel.fontSize = ratio * 45
                    restartLabel.fontName = "SFUIDisplay-Ultralight"
                    restartLabel.position = CGPoint(x: width / 2, y: height / 2 - pauseLabel.frame.height * 0.65 - restartLabel.frame.height)
                    restartLabel.zPosition = 300
                    restartLabel.name = "Restart"
                    pauseBackground.addChild(restartLabel)
                    
                    
                    let exitLabel = SKLabelNode(text: "Exit")
                    exitLabel.fontSize = ratio * 45
                    exitLabel.fontName = "SFUIDisplay-Ultralight"
                    exitLabel.position = CGPoint(x: width / 3 * 2 + restartLabel.frame.width / 2, y: height / 2 - pauseLabel.frame.height * 0.65 - exitLabel.frame.height)
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
                        pauseButton.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                        self.gameNode.unsetStayPaused()
                        self.gameNode.isPaused = false
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
                    if CurrentTime > Double(exporter.song().playbackDuration) {

                        if !FileClass.isExist(String(exporter.songID())+"_custom.mss")
                        { MSSFile.createFile(String(exporter.songID())+"_custom.mss"); MSSFile.openFile(String(exporter.songID())+"_custom.mss") }
                        else
                        { MSSFile.openFile(String(exporter.songID())+"_custom.mss"); MSSFile.write("") }
                        
                        var WriteString = ""
                        for i: Int in 0 ..< timeList[0].count {
                            WriteString += String(timeList[0][i]) + "\t" + String(Int(timeList[1][i])) + "\n"
                        }
                        MSSFile.write(WriteString)
                        
                        
                            Scene = ConfirmScene(size : CGSize(width: width, height: height))
                            View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                        
                        
                    }
                    
                    
                }
            }
        }
    }
    
    
    
    override func didFinishUpdate() {
        /* Put the code here after each frame is rendered. */
        
    }
}
