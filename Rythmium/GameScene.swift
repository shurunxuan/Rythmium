//
//  GameScene.swift
//  UntitledMusicGame
//
//  Created by 舒润萱 on 15/7/7.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import SpriteKit
import Accelerate
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GameNode : SKNode {
    var stayPaused: Bool = false
    
    override var isPaused: Bool {
        get {
            return super.isPaused
        }
        set {
            if (!stayPaused) {
                super.isPaused = newValue
            }
        }
    }
    
    func setStayPaused() {
        if (super.isPaused) {
            self.stayPaused = true
        }
    }
    
    func unsetStayPaused() {
        if (super.isPaused) {
            self.stayPaused = false
        }
    }
}

class GameScene: SKScene {
    
    
    var Init = true
    
    var gameNode = GameNode()
    var countDownLabel = SKLabelNode()
    var titleLabel = SKLabelNode()
    var artistLabel = SKLabelNode()
    var scoreLabel = SKLabelNode(text: "SCORE: 00000000")
    
    var MSSFile = FileClass()
    
    var timeList = [[Double](), [Double](), [Double](), [Double]()]
    var NotePointer = [[1, 1], [1, 1], [1, 1], [1, 1]] // Appear, Hit
    
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
    var AppearStop = [false, false, false, false]
    
    var DisplayingNoteList = [[Note](), [Note](), [Note](), [Note]()]
    
    var appearAction = [SKAction]()
    
    let disappearSequenceNotHit = SKAction.sequence([SKAction.group([SKAction.fadeOut(withDuration: 0.1), SKAction.scale(to: 0.5, duration: 0.1)]), SKAction.removeFromParent()])
    let disappearSequenceHit = SKAction.sequence([SKAction.group([SKAction.fadeOut(withDuration: 0.1), SKAction.scale(to: 1.5, duration: 0.1)]), SKAction.removeFromParent()])
    
    var lifeBackground = SKShapeNode()
    
    var life = 1000
    var lifeDecrease = 1.0
    var WaveFile = FileClass()
    
    var loadDone = false
    
    var max: Double = 0.0
    
    var spectrumBars = [SKShapeNode]()
    
    var barCount = 16
    
    var staticNodeScale: [CGFloat] = [0.5, 0.5, 0.5, 0.5]
    
    var hasLRC: Bool = false
    var LRCPointer: Int = 0
    var LRCLabel = SKLabelNode(text: "")
    
    var spectrumColorOffset: CGFloat = 0
    
    var showLrcLabel = SKLabelNode(text: "Lyrics: On")
    
    var endTime: Double = -10
    
    var touch_particle: [Int : SKEmitterNode] = [:]
    
    var centerMaskCircle = SKShapeNode(circleOfRadius: 60 * ratio)
    var luMaskCircle = SKShapeNode(circleOfRadius: 32 * ratio)
    var ruMaskCircle = SKShapeNode(circleOfRadius: 32 * ratio)
    var ldMaskCircle = SKShapeNode(circleOfRadius: 32 * ratio)
    var rdMaskCircle = SKShapeNode(circleOfRadius: 32 * ratio)
    
    var centerMask = SKCropNode()
    
    var Fft = 0
    
    override func didMove(to view: SKView) {
        Stage = GameStage.game
        
        self.view?.isMultipleTouchEnabled = true
        
        Background = backgroundDark.copy() as! SKSpriteNode
        Background.alpha = 1
        self.addChild(Background)
        if visualizationType == visualization.spectrumCircle { barCount = 24 }
        if visualizationType == visualization.spectrumNormal || visualizationType == visualization.spectrumCircle {
            spectrumBars.reserveCapacity(barCount)
            for bar: Int in 0 ..< barCount {
                if visualizationType == visualization.spectrumNormal {
                    spectrumBars.append(SKShapeNode(rect: CGRect(x: width / CGFloat(barCount) * CGFloat(bar), y: 0, width: width * 0.95 / CGFloat(barCount), height: 1)))
                } else {
                    let Bar = SKShapeNode()
                    let path = CGMutablePath()
                    var transform = CGAffineTransform.identity
                    let zeroPoint = CGPoint.init(x: 0, y: 0)
                    path.addArc(center: zeroPoint, radius: 1, startAngle: -3.1415926535 / 1.05 / CGFloat(barCount), endAngle: 3.1415926535 / 1.05 / CGFloat(barCount), clockwise: false, transform: transform)
                    path.addLine(to: zeroPoint)
                    //CGPathAddArc(path, &transform, 0, 0, 1, -3.1415926535 / 1.05 / CGFloat(barCount), 3.1415926535 / 1.05 / CGFloat(barCount), false)
                    //CGPathAddLineToPoint(path, &transform, 0, 0)
                    path.closeSubpath()
                    Bar.path = path
                    
                    //spectrumBars.append(SKShapeNode(rect: CGRect(x: -width * 0.3 / CGFloat(barCount), y: 0, width: width * 0.6 / CGFloat(barCount), height: 1)))
                    //spectrumBars[bar].position = CGPoint(x: width / 2, y: height / 2)
                    //spectrumBars[bar].zRotation = 2 * 3.1415926535 * (CGFloat(bar) - 3.5) / CGFloat(barCount)
                    Bar.position = CGPoint(x: width / 2, y: height / 2)
                    Bar.zRotation = 2 * 3.1415926535 * (CGFloat(bar) + 0.5) / CGFloat(barCount)
                    spectrumBars.append(Bar)
                }
                
                spectrumBars[bar].alpha = 0.1
                spectrumBars[bar].zPosition = -500
                spectrumBars[bar].strokeColor = SKColor.clear
                spectrumBars[bar].fillColor = brightColorWithHue(CGFloat(bar) / CGFloat(barCount))
                spectrumBars[bar].yScale = 0
                self.addChild(spectrumBars[bar])
            }
        }
        //if visualizationType == visualization.SpectrumCircle { centerMaskCircle.setScale(80.0 / 60.0) }
        
        lifeBackground = SKShapeNode(rectOf: self.size)
        lifeBackground.fillColor = SKColor.red
        lifeBackground.zPosition = -999
        lifeBackground.alpha = 0
        lifeBackground.position = CGPoint(x: width / 2, y: height / 2)
        lifeBackground.strokeColor = SKColor.clear
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
        
        appearAction = [SKAction.group([SKAction.move(to: CGPoint(x: width * 3 / 4, y: height * 3 / 4), duration: AppearDelay), SKAction.scale(to: 1.0, duration: AppearDelay), SKAction.fadeAlpha(to: 0.8, duration: 0.5)]),
            SKAction.group([SKAction.move(to: CGPoint(x: width / 4, y: height * 3 / 4), duration: AppearDelay), SKAction.scale(to: 1.0, duration: AppearDelay), SKAction.fadeAlpha(to: 0.8, duration: 0.5)]),
            SKAction.group([SKAction.move(to: CGPoint(x: width / 4, y: height / 4), duration: AppearDelay), SKAction.scale(to: 1.0, duration: AppearDelay), SKAction.fadeAlpha(to: 0.8, duration: 0.5)]),
            SKAction.group([SKAction.move(to: CGPoint(x: width * 3 / 4, y: height / 4), duration: AppearDelay), SKAction.scale(to: 1.0, duration: AppearDelay), SKAction.fadeAlpha(to: 0.8, duration: 0.5)])]
        
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
        //gameNode.addChild(titleLabel)
        //gameNode.addChild(artistLabel)
        gameNode.addChild(scoreLabel)
        
        
        
        pauseButton = SKSpriteNode(imageNamed: "pauseButton")
        pauseButton.setScale(ratio)
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
        //while titleLabel.frame.width > width * 0.9 || artistLabel.frame.width > width * 0.9 {
        //    titleLabel.fontSize--
        //    artistLabel.fontSize--
        //}
        titleLabel.position = CGPoint(x: width + titleLabel.frame.width / 2, y: height / 2 + countDownLabel.frame.height + titleLabel.frame.height * 0.05)
        artistLabel.position = CGPoint(x: -artistLabel.frame.width / 2, y: height / 2 - countDownLabel.frame.height - artistLabel.frame.height * 1.05)
        
        titleLabel.name = "titleLabel"
        artistLabel.name = "artistLabel"
        
        
        if difficultyType == difficulty.custom {
            MSSFile.openFile(String(exporter.songID())+"_custom.mss")
            let MSSString = MSSFile.read()
            var MSSList = MSSString?.components(separatedBy: "\n")
            for var i in 1 ..< (MSSList?.count)! {
                if !(MSSList?[i].isEmpty)! {
                    let str = MSSList?[i]
                    let list = str?.components(separatedBy: "\t")
                    timeList[Int((list?[1])!)!].append(Double((list?[0])!)!)
                }
            }
        } else {
            MSSFile.openFile(String(exporter.songID())+".mss")
            let MSSString = MSSFile.read()
            var MSSList = MSSString?.components(separatedBy: "\n")
            var strengthList = [Double]()
            strengthList.reserveCapacity((MSSList?.count)!)
            for i in 1 ..< (MSSList?.count)! - 1 {
                strengthList.append(Double((MSSList?[i].components(separatedBy: "\t")[0])!)!)
            }
            strengthList.sort()
            var noteCount: Int
            switch difficultyType {
            case difficulty.easy :
                noteCount = (MSSList?.count)! / 3
            case difficulty.normal :
                noteCount = (MSSList?.count)! / 3 * 2
            case difficulty.hard :
                noteCount = (MSSList?.count)! - 1
            case difficulty.insane :
                noteCount = (MSSList?.count)! / 3 * 2
            default :
                noteCount = (MSSList?.count)! - 1
            }
            let leastStrength = strengthList[strengthList.count - noteCount + 1]
            for i: Int in 1 ..< (MSSList?.count)! - 1 {
                var List = MSSList?[i].components(separatedBy: "\t")
                if Double((List?[0])!) >= leastStrength && Double((List?[1])!) > 0.5 {
                    var maxStrength: Double = 0
                    var maxNote = 0
                    if difficultyType != difficulty.insane {
                        for j in 2 ..< 6 {
                            if Double((List?[j])!)! > maxStrength {
                                maxStrength = Double((List?[j])!)!
                                maxNote = j - 2
                            }
                        }
                        timeList[maxNote].append(Double((List?[1])!)!)
                    } else {
                        if Double((List?[2])!)! != 0.0 || Double((List?[5])!)! != 0.0 {
                            if Double((List?[2])!)! > Double((List?[5])!)! { timeList[0].append(Double((List?[1])!)!) }
                            else { timeList[3].append(Double((List?[1])!)!) }
                        }
                        if Double((List?[3])!)! != 0.0 || Double((List?[4])!)! != 0.0 {
                            if Double((List?[3])!)! > Double((List?[4])!)! { timeList[1].append(Double((List?[1])!)!) }
                            else { timeList[2].append(Double((List?[1])!)!) }
                        }
                    }
                }
            }
        }
        
        for note: Int in 0 ..< 4 {
            staticNodes[note].alpha = 0
            gameNode.addChild(staticNodes[note])
            staticNodes[note].run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.fadeAlpha(to: 0.05, duration: 0.5)]))
            
        }
        scoreLabel.run(SKAction.sequence([SKAction.wait(forDuration: 3), staticNodesAppearAction]))
        
        hasLRC = buildLrcList(exporter.lyrics())
        if hasLRC && showLrc {
            LRCLabel.fontName = "SFUIDisplay-Ultralight"
            LRCLabel.fontSize = 32 * ratio
            LRCLabel.position = CGPoint(x: LRCLabel.frame.width / 2 + 10 * ratio, y: 10 * ratio)
            gameNode.addChild(LRCLabel)
        }
        
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
                    for i in 0 ..< 4 {
                        for note in DisplayingNoteList[i] {
                            note.removeFromParent()
                        }
                        NotePointer[i][0] = NotePointer[i][1]
                        DisplayingNoteList[i].removeAll()
                    }
                    exporter.play()
                    self.gameNode.unsetStayPaused()
                    self.gameNode.isPaused = false
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
                case "showLrcLabel" :
                    if (!showLrc) {
                        showLrcLabel.text = "Lyrics: On"
                        gameNode.addChild(LRCLabel)
                    }
                    else {
                        showLrcLabel.text = "Lyrics: Off"
                        LRCLabel.removeFromParent()
                    }
                    showLrc = !showLrc
                    showLrcLabel.position = CGPoint(x: width / 8 * 7, y: height / 8 - showLrcLabel.frame.height / 2)
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
                        let judge = Judgement(CurrentTime, NoteTime: DisplayingNoteList[pos][0].Time)
                        let displayingNote = DisplayingNoteList[pos].remove(at: 0)
                        staticNodes[pos].removeAllActions()
                        staticNodes[pos].alpha = 0.4
                        switch judge {
                        case 4 :
                            staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 250.0 / 255.0, green: 191.0 / 255.0, blue: 87.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                        case 3 :
                            staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 202.0 / 255.0, green: 202.0 / 255.0, blue: 202.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                        case 2 :
                            staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 166.0 / 255.0, green: 221.0 / 255.0, blue: 116.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                        case 1 :
                            staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 144.0 / 255.0, green: 173.0 / 255.0, blue: 223.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                        case 0 :
                            staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 130.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                        default :
                            break
                        }
                        
                        let colorizeAction1 = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.5)
                        colorizeAction1.timingMode = SKActionTimingMode.easeIn
                        let colorizeAction2 = SKAction.fadeAlpha(to: 0.05, duration: 0.5)
                        colorizeAction2.timingMode = SKActionTimingMode.easeIn
                        staticNodes[pos].run(SKAction.group([colorizeAction1, colorizeAction2]))
                        displayingNote.run(disappearSequenceHit)
                        NotePointer[pos][1] += 1
                    }
                }
                
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
                //let t0 = CGFloat(CurrentTime + 3.5)
                //let t1 = CGFloat(CurrentTime + 3.5)
                //let X_A = CGFloat(1)
                //let f0 = (t0-X_A)*(t0-X_A)*(t0-X_A)
                //let f1 = (X_A*X_A*X_A)
                //let f00 = f0 / f1
                //let f01 = (width + titleLabel.frame.width) / 2
                //let f10 = (t1-X_A)*(t1-X_A)*(t1-X_A)/(X_A*X_A*X_A)
                //let f11 = (width + artistLabel.frame.width) / 2
                
                //let EW = width / 8 // Ease in width
                //let ET: CGFloat = 0.4 // Ease in time
                //
                //let FW_1 = titleLabel.frame.width // frame width
                //let v1_1_t1 = FW_1 + width - 2 * EW
                //let v_t = 3 - 2 * ET
                //let v1_1 = v1_1_t1 / v_t
                //let v0_1 = (2 * EW / ET) - v1_1
                //let a_1 = (v0_1 - v1_1) / ET
                //let FW_2 = artistLabel.frame.width // frame width
                //let v1_2_t1 = FW_2 + width - 2 * EW
                //let v1_2 = v1_2_t1 / v_t
                //let v0_2 = (2 * EW / ET) - v1_2
                //let a_2 = (v0_2 - v1_2) / ET
                //let t = (CGFloat(CurrentTime) + 3.9)
                //if t > 3 - ET {
                //    titleLabel.position.x = width - (FW_1 / 2 + width - EW + v1_1 * (t - 3 + ET) + 0.5 * a_1 * (t - 3 + ET) * (t - 3 + ET))
                //    artistLabel.position.x = FW_2 / 2 + width - EW + v1_2 * (t - 3 + ET) + 0.5 * a_2 * (t - 3 + ET) * (t - 3 + ET)
                //} else if t > ET {
                //    titleLabel.position.x = width - (EW + v1_1 * (t - ET) - FW_1 / 2)
                //    artistLabel.position.x = EW + v1_2 * (t - ET) - FW_2 / 2
                //} else {
                //    titleLabel.position.x = width - (v0_1 * t - 0.5 * a_1 * t * t - FW_1 / 2)
                //    artistLabel.position.x = v0_2 * t - 0.5 * a_2 * t * t - FW_2 / 2
                //}
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
                    startTime = exporter.player().currentTime().seconds
                    exporter.player().seek(to: CMTime(seconds: exporter.player().currentTime().seconds - 3.0, preferredTimescale: 1))
                    exporter.player().pause()
                    
                    self.gameNode.isPaused = true
                    gameNode.setStayPaused()
                    
                    self.childNode(withName: "titleLabel")?.removeFromParent()
                    self.childNode(withName: "aritstLabel")?.removeFromParent()
                    for node in staticNodes { node.alpha = 0.05 }
                    
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
                    
                    let settingButton = SKSpriteNode(imageNamed: "setting")
                    settingButton.setScale(ratio)
                    settingButton.position = CGPoint(x: width - settingButton.frame.width * 0.55, y: height - settingButton.frame.height * 0.55)
                    settingButton.zPosition = 300
                    settingButton.name = "settingButton"
                    //pauseBackground.addChild(settingButton)
                    
                    if hasLRC {
                        if (!showLrc) { showLrcLabel.text = "Lyrics: Off" }
                        showLrcLabel.fontName = "SFUIDisplay-Ultralight"
                        showLrcLabel.fontSize = 32 * ratio
                        showLrcLabel.position = CGPoint(x: width / 8 * 7, y: height / 8 - showLrcLabel.frame.height / 2)
                        showLrcLabel.name = "showLrcLabel"
                        showLrcLabel.zPosition = 300
                        pauseBackground.addChild(showLrcLabel)
                        LRCLabel.text = ""
                    }
                    pauseBackground.zPosition = 1001
                    
                    pauseBackground.alpha = 1
                    
                    pauseButton.alpha = 0
                    self.addChild(pauseBackground)
                    GameScene.pauseInit = false
                }
                
            } else {
                CurrentTime = CMTimeGetSeconds(exporter.player().currentTime())
                if GameScene.pauseInit {
                    //CurrentTime = Double(currentTime) - startTime
                    if Int(CurrentTime - startTime) < 0 {
                        countDownLabel.text = String(-Int(CurrentTime - startTime))
                    }
                    if Int(CurrentTime - startTime) == 0 {
                        countDownLabel.text = "START!"
                    }
                    if CurrentTime > startTime {
                        
                        countDownLabel.removeFromParent()
                        pauseButton.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                        GameScene.pauseInit = false
                    }
                    
                    
                }
                var i = Int(CurrentTime * 44100.0)
                if i < 0 { i = 0 }
                
                if colorfulTheme { spectrumColorOffset += 0.01 }
                
                // visualization
                if visualizationType == visualization.spectrumNormal || visualizationType == visualization.spectrumCircle && Fft == 0 {
                    let q: CGFloat = pow(2.0, 1.0 / (CGFloat(barCount) / 8.0))
                    var a1: CGFloat = 1
                    let s = Int(a1 / (q - 1) * (pow(q, CGFloat(barCount)) - 1)) * 2
                    let block = fft(Array(Left[i ..< i + s]))
                    
                    for bar: Int in 0 ..< barCount {
                        var x = sum(Array(block[Int(a1) - 1 ..< Int(a1 * q)]))
                        x -= block[Int(a1) - 1] * Double(a1 - floor(a1))
                        x += block[Int(a1 * q)] * Double(a1 * q - floor(a1 * q))
                        x *= (1.0 + Double(barCount - bar) / Double(barCount) * 3.0)
                        if visualizationType == visualization.spectrumNormal {
                            spectrumBars[bar].run(SKAction.scaleY(to: CGFloat(x) / log(CGFloat(barCount)) * 2 / 30000.0 * height, duration: 0.05))
                        } else {
                            spectrumBars[bar].run(SKAction.scale(to: (CGFloat(x) / log(CGFloat(barCount)) * 2 / 35000.0 * height + 60 * ratio), duration: 0.05))
                        }
                        a1 *= q
                        spectrumBars[bar].fillColor = brightColorWithHue((CGFloat(bar) / CGFloat(barCount) + spectrumColorOffset) - CGFloat(Int(CGFloat(bar) / CGFloat(barCount) + spectrumColorOffset)))
                    }
                    if visualizationType == visualization.spectrumNormal {
                        centerMaskCircle.setScale((CGFloat(sum(block)) / 10000.0 + 60.0 * ratio) / (60.0 * ratio))
                    }
                }
                
                Fft = (Fft + 1) % 3
                
                // lyrics
                if hasLRC {
                    if CurrentTime > LrcTimeList[LRCPointer] {
                        //print(LrcList[Double(LrcTimeList[LRCPointer])])
                        LRCLabel.text = LrcList[Double(LrcTimeList[LRCPointer])]!
                        //LRCLabel.position = CGPointMake(LRCLabel.frame.width / 2 + 10 * ratio, 10 * ratio)
                        if LRCLabel.frame.width < width - 20 * ratio {
                            LRCLabel.position = CGPoint(x: width / 2, y: 10 * ratio)
                        } else {
                            var timeToNextLrc: Double = 0
                            if LRCPointer + 1 == LrcTimeList.count { timeToNextLrc = 3 }
                            else { timeToNextLrc = LrcTimeList[LRCPointer + 1] - LrcTimeList[LRCPointer] }
                            let stillDuration = timeToNextLrc * 0.5
                            let moveDuration = timeToNextLrc * 0.3
                            LRCLabel.position = CGPoint(x: 10 * ratio + LRCLabel.frame.width / 2, y: 10 * ratio)
                            let moveAction = SKAction.moveTo(x: width - 10 * ratio - LRCLabel.frame.width / 2, duration: moveDuration)
                            moveAction.timingMode = SKActionTimingMode.easeInEaseOut
                            LRCLabel.run(SKAction.sequence([SKAction.wait(forDuration: stillDuration), moveAction]))
                        }
                        LRCPointer += 1
                        if LRCPointer == LrcTimeList.count {
                            LRCLabel.text = ""
                            hasLRC = false
                        }
                    }
                }
                
                // note appear
                for pos: Int in 0 ..< 4 {
                    if !AppearStop[pos] && CurrentTime + AppearDelay > timeList[pos][NotePointer[pos][0]] {
                        DisplayingNoteList[pos].append(Note(
                            time: timeList[pos][NotePointer[pos][0]],
                            center: CGPoint(x: self.frame.midX, y: self.frame.midY),
                            radius: 60 * ratio))
                        
                        gameNode.addChild(DisplayingNoteList[pos].last!)
                        DisplayingNoteList[pos].last!.run(appearAction[pos])
                        NotePointer[pos][0] += 1
                        if NotePointer[pos][0] >= timeList[pos].count {
                            NotePointer[pos][0] -= 1
                            AppearStop[pos] = true
                        }
                    }
                }
                
                // note not hit, disappear
                for pos: Int in 0 ..< 4 {
                    if NotePointer[pos][1] < timeList[pos].count {
                        if CurrentTime - 0.3 > timeList[pos][NotePointer[pos][1]] {
                            // miss judge
                            let judge = Judgement(CurrentTime, NoteTime: DisplayingNoteList[pos][0].Time)
                            let displayingNote = DisplayingNoteList[pos].remove(at: 0)
                            staticNodes[pos].removeAllActions()
                            staticNodes[pos].alpha = 0.4
                            switch judge {
                            case 4 :
                                staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 250.0 / 255.0, green: 191.0 / 255.0, blue: 87.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                            case 3 :
                                staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 202.0 / 255.0, green: 202.0 / 255.0, blue: 202.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                            case 2 :
                                staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 166.0 / 255.0, green: 221.0 / 255.0, blue: 116.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                            case 1 :
                                staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 144.0 / 255.0, green: 173.0 / 255.0, blue: 223.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                            case 0 :
                                staticNodes[pos].run(SKAction.colorize(with: UIColor.init(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 130.0 / 255.0, alpha: 1), colorBlendFactor: 1, duration: 0))
                            default :
                                break
                            }
                            
                            let colorizeAction1 = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.5)
                            colorizeAction1.timingMode = SKActionTimingMode.easeIn
                            let colorizeAction2 = SKAction.fadeAlpha(to: 0.05, duration: 0.5)
                            colorizeAction2.timingMode = SKActionTimingMode.easeIn
                            staticNodes[pos].run(SKAction.group([colorizeAction1, colorizeAction2]))
                            displayingNote.run(disappearSequenceNotHit)
                            NotePointer[pos][1] += 1
                        }
                    }
                }
                
                // debug only
                //if CurrentTime > 1 {
                //    for var differentJudge: Int = 0; differentJudge < 5; differentJudge++ {
                //        differentJudges[differentJudge] = differentJudge + 1000
                //    }
                //    Scene = ResultScene(size : CGSizeMake(width, height))
                //    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                //}
                
                // end of game
                if NotePointer[0][1] >= timeList[0].count && NotePointer[1][1] >= timeList[1].count && NotePointer[2][1] >= timeList[2].count && NotePointer[3][1] >= timeList[3].count {
                    if endTime < 0 { endTime = CurrentTime }
                    if CurrentTime - endTime > 1 {
                        totalScore -= 4500
                        Scene = ResultScene(size : CGSize(width: width, height: height))
                        View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                    }
                }
            }
        }
    }
    
    
    
    override func didFinishUpdate() {
        /* Put the code here after each frame is rendered. */
        
    }
    
    
    func Judgement(_ HitTime: Double, NoteTime: Double) -> Int {
        let judge = JudgementLabel(combo: &combo, HitTime: HitTime, NoteTime: NoteTime)
        for node in self.children where node.name == "JudgementLabel"
        { node.removeFromParent() }
        judge.runAction()
        self.addChild(judge)
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
                Scene = ResultScene(size : CGSize(width: width, height: height))
                let rScene = Scene as! ResultScene
                rScene.isGameOver = true
                exporter.player().pause()
                View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
            }
        }
        let B: CGFloat = 50.0
        lifeBackground.run(SKAction.fadeAlpha(to: ((B+1000.0)*B/(CGFloat(life)-(B+1000.0))+(B+1000.0))/5000.0, duration: 0.2))
        score += judge.score + (combo > 10 ? 10 : combo) * 100
        if score < 0 { score = 0 }
        totalScore += 2000
        scoreLabel.text = NSString(format: "SCORE: %08i", score) as String
        scoreLabel.position = CGPoint(x: width - scoreLabel.frame.width * 0.6, y: height - scoreLabel.frame.height * 1.2)
        differentJudges[judge.judge] += 1
        return judge.judge
    }
}

