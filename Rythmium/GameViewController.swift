//
//  GameViewController.swift
//  UntitledMusicGame
//
//  Created by 舒润萱 on 15/7/7.
//  Copyright (c) 2015年 舒润萱. All rights reserved.
//

import UIKit
import SpriteKit

// Enumerate type that indicates the stage of the game.
enum GameStage {
    case StartUp, Setting, Choose, Confirm, Analyze, Game, Result, About
}
// Enumerate type that indicates the type of visualization, some more will be added.
enum visualization {
    case Spectrum, None
}
// Enumerate type that indicates difficulty.
enum difficulty {
    case easy, normal, hard, insane
}

var Stage = GameStage.StartUp                       // stage of the game
var Scene: SKScene = SKScene()                      // presented scene
var exporter: MediaLibExport = MediaLibExport()     // export & play the music
var width: CGFloat = 0                              // width
var height: CGFloat = 0                             // height
var ratio: CGFloat = 1
let staticNodesAppearAction = SKAction.fadeAlphaTo(1, duration: 0.5)
let staticNodesDisappearAction = SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5), SKAction.removeFromParent()])
var background = SKSpriteNode()

var backgrounds = [SKSpriteNode(texture: SKTexture(imageNamed: "Background1")), SKSpriteNode(texture: SKTexture(imageNamed: "Background2")), SKSpriteNode(texture: SKTexture(imageNamed: "Background3")), SKSpriteNode(texture: SKTexture(imageNamed: "Background4")), SKSpriteNode(texture: SKTexture(imageNamed: "Background5"))]
var isNormalBackground = true

var score: Int = 0
var totalScore: Int = 0
var combo: Int = 0
var maxCombo: Int = 0
var fullCombo = true
var differentJudges = [0, 0, 0, 0, 0]

var visualizationType = visualization.Spectrum
var difficultyType = difficulty.easy

var View = SKView()

var artViewBackground: MPMediaItemArtwork?

var Left = [Int16]()

var settingFile = FileClass()
var hasBestScore = false
var bestScore = 0

var settings: [String : String] = [:]

var LrcList: [Double : String] = [:]
var LrcTimeList = [Double]()
var showLrc: Bool = true

var colorfulTheme: Bool = true


class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.addChildViewController(exporter)
        
        // Configure the view.
        let skView = self.view as! SKView
        View = skView
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        Scene = StartUpScene(size : skView.bounds.size)
        
        width = Scene.frame.width
        height = Scene.frame.height
        ratio = width / 736.0
        
        for child in backgrounds {
            child.size = CGSizeMake(width, height)
            child.position = CGPointMake(width / 2, height / 2)
            child.zPosition = -1000
        }
        
        // read settings
        if !FileClass.isExist("setting.cfg") {
            settingFile.CreateFile("setting.cfg")
            settingFile.Write("Visualization\tSpectrum\nDifficulty\teasy\nLRC\tYes\ncolorfulTheme\tOff\n")
        }
        settingFile.OpenFile("setting.cfg")
        let settingStr = settingFile.Read()
        let settingStrs = settingStr.componentsSeparatedByString("\n")
        for set in settingStrs {
            if set != "" {
                let detail = set.componentsSeparatedByString("\t")
                let content = detail[0]
                let value = detail[1]
                settings[content] = value
                switch content {
                case "Visualization" :
                    switch value {
                    case "Spectrum" :
                        visualizationType = visualization.Spectrum
                    case "None" :
                        visualizationType = visualization.None
                    default :
                        NSLog("ERROR, type Visualization setting")
                        break
                    }
                case "Difficulty" :
                    switch value {
                    case "easy" :
                        difficultyType = difficulty.easy
                    case "normal" :
                        difficultyType = difficulty.normal
                    case "hard" :
                        difficultyType = difficulty.hard
                    case "insane" :
                        difficultyType = difficulty.insane
                    default :
                        NSLog("ERROR, type Difficulty setting")
                    }
                case "LRC" :
                    switch value {
                    case "Yes" :
                        showLrc = true
                    case "No" :
                        showLrc = false
                    default :
                        NSLog("ERROR, type LRC setting")
                    }
                case "colorfulTheme" :
                    switch value{
                    case "On" :
                        colorfulTheme = true
                    case "Off" :
                        colorfulTheme = false
                    default :
                        NSLog("ERROR, type colorfulTheme setting")
                    }
                default :
                    break
                }
            }
        }
        
        
        
        /* Set the scale mode to scale to fit the window */
        Scene.scaleMode = .AspectFill
        
        skView.presentScene(Scene)

    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Landscape
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
