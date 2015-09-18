    //
    //  GameScene.swift
    //  UntitledMusicGame
    //
    //  Created by 舒润萱 on 15/7/7.
    //  Copyright © 2015年 舒润萱. All rights reserved.
    //
    
    import SpriteKit
    import Accelerate
    
    class GameScene: SKScene {
        
        
        var Init = true
        
        var gameNode = SKNode()
        var countDownLabel = SKLabelNode()
        var titleLabel = SKLabelNode()
        var artistLabel = SKLabelNode()
        var scoreLabel = SKLabelNode(text: "SCORE: 00000000")
        
        var MSSFile = FileClass()
        
        var timeList = [[Double](), [Double](), [Double](), [Double]()]
        var NotePointer = [[1, 1], [1, 1], [1, 1], [1, 1]] // Appear, Hit
        
        var staticNodes = [Note]()
        
        var startTime: Double = 0.0
        
        
        var playing = false
        
        var CurrentTime: Double = 0.0
        
        var pauseButton = SKSpriteNode()
        static var pause = false
        static var pauseInit = false
        var pauseBackground = SKSpriteNode()
        var Background = SKSpriteNode()
        
        let AppearDelay = 1.0
        var AppearStop = [false, false, false, false]
        
        var DisplayingNoteList = [[Note](), [Note](), [Note](), [Note]()]
        
        var appearAction = [SKAction]()
        
        let disappearSequenceNotHit = SKAction.sequence([SKAction.group([SKAction.fadeOutWithDuration(0.1), SKAction.scaleTo(0.5, duration: 0.1)]), SKAction.removeFromParent()])
        let disappearSequenceHit = SKAction.sequence([SKAction.group([SKAction.fadeOutWithDuration(0.1), SKAction.scaleTo(1.5, duration: 0.1)]), SKAction.removeFromParent()])
        
        var lifeBackground = SKShapeNode()
        
        var life = 1000
        var lifeDecrease = 1.0
        var WaveFile = FileClass()
        
        var loadDone = false
        
        var max: Double = 0.0
        
        var spectrumBars = [SKShapeNode]()
        
        let barCount = 16
        
        var staticNodeScale: [CGFloat] = [0.5, 0.5, 0.5, 0.5]
        
        override func didMoveToView(view: SKView) {
            Stage = GameStage.Game
            
            
            Background = background.copy() as! SKSpriteNode
            Background.alpha = 1
            self.addChild(Background)
            
            if visualizationType == visualization.Spectrum {
                spectrumBars.reserveCapacity(barCount)
                for var bar: Int = 0; bar < barCount; ++bar {
                    spectrumBars.append(SKShapeNode(rect: CGRect(x: width / CGFloat(barCount) * CGFloat(bar), y: 0, width: width * 0.8 / CGFloat(barCount), height: 1)))
                    
                    spectrumBars[bar].alpha = 0.1
                    spectrumBars[bar].zPosition = -500
                    spectrumBars[bar].strokeColor = SKColor.clearColor()
                    spectrumBars[bar].fillColor = SKColor.whiteColor()
                    self.addChild(spectrumBars[bar])
                }
            }
            
            
            lifeBackground = SKShapeNode(rectOfSize: self.size)
            lifeBackground.fillColor = SKColor.redColor()
            lifeBackground.zPosition = -999
            lifeBackground.alpha = 0
            lifeBackground.position = CGPointMake(width / 2, height / 2)
            lifeBackground.strokeColor = SKColor.clearColor()
            self.addChild(lifeBackground)
            timeList = [[Double](), [Double](), [Double](), [Double]()]
            NotePointer = [[1, 1], [1, 1], [1, 1], [1, 1]] // Appear, Hit
            
            CurrentTime = 0.0
            
            
            DisplayingNoteList = [[Note](), [Note](), [Note](), [Note]()]
            
            playing = false
            
            AppearStop = [false, false, false, false]
            
            score = 0
            totalScore = 0
            combo = 0
            maxCombo = 0
            fullCombo = true
            
            differentJudges = [0, 0, 0, 0, 0]
            
            scoreLabel.text = "SCORE: 00000000"
            
            appearAction = [SKAction.group([SKAction.moveTo(CGPointMake(width * 3 / 4, height * 3 / 4), duration: AppearDelay), SKAction.scaleTo(1.0, duration: AppearDelay), SKAction.fadeAlphaTo(0.8, duration: 0.5)]),
                SKAction.group([SKAction.moveTo(CGPointMake(width / 4, height * 3 / 4), duration: AppearDelay), SKAction.scaleTo(1.0, duration: AppearDelay), SKAction.fadeAlphaTo(0.8, duration: 0.5)]),
                SKAction.group([SKAction.moveTo(CGPointMake(width / 4, height / 4), duration: AppearDelay), SKAction.scaleTo(1.0, duration: AppearDelay), SKAction.fadeAlphaTo(0.8, duration: 0.5)]),
                SKAction.group([SKAction.moveTo(CGPointMake(width * 3 / 4, height / 4), duration: AppearDelay), SKAction.scaleTo(1.0, duration: AppearDelay), SKAction.fadeAlphaTo(0.8, duration: 0.5)])]
            
            staticNodes = [Note(time: 0, center: CGPointMake(CGFloat(width / 4 * 3),CGFloat(height / 4 * 3)), radius: 140 * ratio),
                Note(time: 0, center: CGPointMake(CGFloat(width / 4),CGFloat(height / 4 * 3)), radius: 140 * ratio),
                Note(time: 0, center: CGPointMake(CGFloat(width / 4),CGFloat(height / 4)), radius: 140 * ratio),
                Note(time: 0, center: CGPointMake(CGFloat(width / 4 * 3),CGFloat(height / 4)), radius: 140 * ratio)]
            
            for node in staticNodes {
                node.fillColor = SKColor.whiteColor()
                node.strokeColor = SKColor.clearColor()
            }
            
            scoreLabel.fontName = "Helvetica Neue UltraLight"
            scoreLabel.fontSize = ratio * 20
            scoreLabel.position = CGPointMake(width - scoreLabel.frame.width * 0.6, height - scoreLabel.frame.height * 1.2)
            scoreLabel.alpha = 0
            scoreLabel.text = "SCORE: 00000000"
            
            
            countDownLabel.text = "3"
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
            while titleLabel.frame.width > width * 0.9 || artistLabel.frame.width > width * 0.9 {
                titleLabel.fontSize--
                artistLabel.fontSize--
            }
            titleLabel.position = CGPointMake(width + titleLabel.frame.width / 2, height / 2 + countDownLabel.frame.height + titleLabel.frame.height * 0.05)
            artistLabel.position = CGPointMake(-artistLabel.frame.width / 2, height / 2 - countDownLabel.frame.height - artistLabel.frame.height * 1.05)
            
            MSSFile.OpenFile(String(exporter.songID())+".mss")
            let MSSString = MSSFile.Read()
            var MSSList = MSSString.componentsSeparatedByString("\n")
            for var i: Int = 1; i < MSSList.count - 1; i++ {
                var List = MSSList[i].componentsSeparatedByString("\t")
                var maxStrength: Double = 0
                var maxNote = 0
                for var j = 2; j < 6; ++j {
                    if Double(List[j])! > maxStrength {
                        maxStrength = Double(List[j])!
                        maxNote = j - 2
                    }
                }
                timeList[maxNote].append(Double(List[1])!)
            }
            
            for var note: Int = 0; note < 4; ++note {
                staticNodes[note].alpha = 0
                gameNode.addChild(staticNodes[note])
                staticNodes[note].runAction(SKAction.sequence([SKAction.waitForDuration(3), SKAction.fadeAlphaTo(0.15, duration: 0.5)]))
                
            }
            scoreLabel.runAction(SKAction.sequence([SKAction.waitForDuration(3), staticNodesAppearAction]))
            
            //startTime = Double(currentTime) + 4
            
            self.addChild(gameNode)
            
            
        }
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            /* Called when a touch begins */
            
            for touch in touches {
                let location = touch.locationInNode(self)
                let node = self.nodeAtPoint(location)
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
                        //pauseBackground.removeAllChildren()
                        //pauseBackground.removeFromParent()
                        for nodes in self.children {
                            let node = nodes as SKNode
                            node.runAction(staticNodesDisappearAction)
                        }
                        //exporter.player().seekToTime(exporter.player().currentItem.asset.duration)
                        //exporter.player().play()
                        //exporter.player().replaceCurrentItemWithPlayerItem(nil)
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
                    
                    if NotePointer[pos][1] < timeList[pos].count {
                        if timeList[pos][NotePointer[pos][1]] - CurrentTime < 0.3 {
                            Judgement(pos, HitTime: CurrentTime, NoteTime: DisplayingNoteList[pos][0].Time)
                            let displayingNote = DisplayingNoteList[pos].removeAtIndex(0)
                            displayingNote.runAction(disappearSequenceHit)
                            NotePointer[pos][1]++
                        }
                    }
                    
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
                //CurrentTime = CMTimeGetSeconds(exporter.player().currentTime())
                
                if GameScene.pause {
                    if GameScene.pauseInit {
                        
                        exporter.player().pause()
                        
                        self.gameNode.paused = true
                        for child in gameNode.children {
                            child.paused = true
                        }
                        let pauseLabel = SKLabelNode(text: "PAUSED")
                        pauseLabel.fontSize = ratio * 70
                        pauseLabel.position = CGPointMake(width / 2, height * 0.65 - pauseLabel.frame.height / 2)
                        pauseLabel.zPosition = 300
                        pauseBackground.addChild(pauseLabel)
                        
                        
                        let bgcopy = Background.copy() as! SKNode
                        bgcopy.zPosition = 299
                        pauseBackground.addChild(bgcopy)
                        
                        
                        let resumeLabel = SKLabelNode(text: "Resume")
                        resumeLabel.fontSize = ratio * 45
                        resumeLabel.position = CGPointMake(width / 3 - resumeLabel.frame.width / 2, height / 2 - pauseLabel.frame.height * 0.65 - resumeLabel.frame.height)
                        resumeLabel.zPosition = 300
                        resumeLabel.name = "Resume"
                        pauseBackground.addChild(resumeLabel)
                        
                        
                        let restartLabel = SKLabelNode(text: "Restart")
                        restartLabel.fontSize = ratio * 45
                        restartLabel.position = CGPointMake(width / 2, height / 2 - pauseLabel.frame.height * 0.65 - restartLabel.frame.height)
                        restartLabel.zPosition = 300
                        restartLabel.name = "Restart"
                        pauseBackground.addChild(restartLabel)
                        
                        
                        let exitLabel = SKLabelNode(text: "Exit")
                        exitLabel.fontSize = ratio * 45
                        exitLabel.position = CGPointMake(width / 3 * 2 + restartLabel.frame.width / 2, height / 2 - pauseLabel.frame.height * 0.65 - exitLabel.frame.height)
                        exitLabel.zPosition = 300
                        exitLabel.name = "Exit"
                        pauseBackground.addChild(exitLabel)
                        pauseBackground.zPosition = 1001
                        
                        pauseBackground.alpha = 1
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
                            for child in gameNode.children {
                                child.paused = false
                            }
                            self.gameNode.paused = false
                            GameScene.pauseInit = false
                        }
                        
                        
                    } else {
                        CurrentTime = CMTimeGetSeconds(exporter.player().currentTime())
                        var i = Int(CurrentTime * 44100.0)
                        if i < 0 { i = 0 }
                        
                        // static nodes scale change
                        for var i = 0; i < 4; ++i {
                            staticNodeScale[i] = (staticNodeScale[i] - 0.5) * 0.8 + 0.5
                            staticNodes[i].runAction(SKAction.scaleTo(staticNodeScale[i], duration: 0.05))
                        }
                        
                        // visualization
                        if visualizationType == visualization.Spectrum {
                            let q: CGFloat = pow(2.0, 1.0 / (CGFloat(barCount) / 8.0))
                            var a1: CGFloat = 1
                            let s = Int(a1 / (q - 1) * (pow(q, CGFloat(barCount)) - 1)) * 2
                            let block = fft(Array(Left[i ..< i + s]))
                            
                            for var bar: Int = 0; bar < barCount; ++bar {
                                //let a = Int(512 / Double(barCount) * Double(bar))
                                //let b = Int(512.0 / Double(barCount) * Double(bar + 1))
                                var x = sum(Array(block[Int(a1) - 1 ..< Int(a1 * q)]))
                                x -= block[Int(a1) - 1] * Double(a1 - floor(a1))
                                x += block[Int(a1 * q)] * Double(a1 * q - floor(a1 * q))
                                //spectrumBars[bar].yScale = CGFloat(x) / 15000.0 * height
                                //spectrumBars[bar].removeAllActions()
                                spectrumBars[bar].runAction(SKAction.scaleYTo(CGFloat(x) / log(CGFloat(barCount)) * 2 / 20000.0 * height, duration: 0.1))
                                a1 *= q
                            }
                        }
                        
                        // note appear
                        for var pos: Int = 0; pos < 4; pos++ {
                            if !AppearStop[pos] && CurrentTime + AppearDelay > timeList[pos][NotePointer[pos][0]] {
                                DisplayingNoteList[pos].append(Note(
                                    time: timeList[pos][NotePointer[pos][0]],
                                    center: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)),
                                    radius: 60 * ratio))
                                
                                gameNode.addChild(DisplayingNoteList[pos].last!)
                                DisplayingNoteList[pos].last!.runAction(appearAction[pos])
                                NotePointer[pos][0]++
                                if NotePointer[pos][0] >= timeList[pos].count {
                                    NotePointer[pos][0]--
                                    AppearStop[pos] = true
                                }
                            }
                        }
                        
                        // note not hit, disappear
                        for var pos: Int = 0; pos < 4; pos++ {
                            if NotePointer[pos][1] < timeList[pos].count {
                                if CurrentTime - 0.3 > timeList[pos][NotePointer[pos][1]] {
                                    // miss judge
                                    Judgement(pos, HitTime: CurrentTime, NoteTime: DisplayingNoteList[pos][0].Time)
                                    let displayingNote = DisplayingNoteList[pos].removeAtIndex(0)
                                    displayingNote.runAction(disappearSequenceNotHit)
                                    NotePointer[pos][1]++
                                }
                            }
                        }
                        
                        // end of game
                        if NotePointer[0][1] >= timeList[0].count &&
                            NotePointer[1][1] >= timeList[1].count &&
                            NotePointer[2][1] >= timeList[2].count &&
                            NotePointer[3][1] >= timeList[3].count {
                                //scoreLabel.runAction(staticNodesDisappearAction)
                                //for var note: Int = 0; note < 4; note++ {
                                //    staticNodes[note].runAction(staticNodesDisappearAction)
                                //}
                                //gameNode.runAction(staticNodesDisappearAction)
                                totalScore -= 4500
                                Scene = ResultScene(size : CGSizeMake(width, height))
                                View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                                
                                //pauseButton.runAction(SKAction.sequence([SKAction.waitForDuration(0.5), SKAction.removeFromParent()]))
                        }
                    }
                }
            }
            
        }
        
        
        
        override func didFinishUpdate() {
            /* Put the code here after each frame is rendered. */
            
        }
        
        
        func Judgement(type: Int, HitTime: Double, NoteTime: Double) {
            let judge = JudgementLabel(type: type, HitTime: HitTime, NoteTime: NoteTime) // problems happen here
            gameNode.addChild(judge)
            judge.runAction()
            if judge.judge > 2 {
                staticNodeScale[type] = CGFloat(judge.judge) / 6.0
                staticNodes[type].xScale = CGFloat(judge.judge) / 6.0
                staticNodes[type].yScale = CGFloat(judge.judge) / 6.0
                combo += 1
                if combo > maxCombo { maxCombo = combo }
            } else {
                combo = 0
                fullCombo = false
            }
            if judge.judge > 2 {
                if lifeDecrease > 0 { lifeDecrease = -2 }
                lifeDecrease *= Double(judge.judge) / 2.5
                if lifeDecrease <= -60 { lifeDecrease = -60 }
                life -= Int(lifeDecrease)
                if life >= 1000 { life = 1000 }
            }
            else if judge.judge < 2 {
                if lifeDecrease < 0 { lifeDecrease = 2 }
                lifeDecrease *= Double(judge.judge + 3) / 2.5
                if lifeDecrease >= 120 { lifeDecrease = 120 }
                life -= Int(lifeDecrease)
                if life <= 0 {
                    life = 1000
                    Scene = ResultScene(size : CGSizeMake(width, height))
                    let rScene = Scene as! ResultScene
                    rScene.isGameOver = true
                    exporter.player().pause()
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                }
            }
            let B: CGFloat = 50.0
            //lifeBackground.runAction(SKAction.fadeAlphaTo(CGFloat(1000 - life) * 2.0 / 10000.0, duration: 0.2))
            lifeBackground.runAction(SKAction.fadeAlphaTo(((B+1000.0)*B/(CGFloat(life)-(B+1000.0))+(B+1000.0))/5000.0, duration: 0.2))
            score += judge.score + (combo > 10 ? 10 : combo) * 100
            if score < 0 { score = 0 }
            totalScore += 2000
            scoreLabel.text = NSString(format: "SCORE: %08i", score) as String
            scoreLabel.position = CGPointMake(width - scoreLabel.frame.width * 0.6, height - scoreLabel.frame.height * 1.2)
            differentJudges[judge.judge]++
            
        }
    }
    
