//
//  SettingScene.swift
//  UntitledMusicGame
//
//  Created by 舒润萱 on 15/8/11.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import SpriteKit

class SettingScene: SKScene {
    
    var backButton = SKLabelNode(text: "Back")
    
    var visualizationLabel = SKLabelNode(text: "Visualization")
    var visualizationSpectrumButton = SKLabelNode(text: "Spectrum")
    var visualizationNoneButton = SKLabelNode(text: "None")
    var visualizationIndicator = [SKShapeNode(), SKShapeNode()]
    
    var lrcLabel = SKLabelNode(text: "Show Lyrics")
    var lrcYesButton = SKLabelNode(text: "YES")
    var lrcNoButton = SKLabelNode(text: "NO")
    var lrcIndicator = [SKShapeNode(), SKShapeNode()]
    
    var Background = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.Setting
        
        backButton.fontName = "Helvetica Neue UltraLight"
        backButton.name = "backButton"
        backButton.fontSize = 32 * ratio
        backButton.position = CGPointMake(width / 8, height / 8 - backButton.frame.height / 2)
        
        visualizationLabel.fontName = "Helvetica Neue UltraLight"
        visualizationLabel.name = "visualizationLabel"
        visualizationLabel.fontSize = 32 * ratio
        visualizationLabel.position = CGPointMake(width / 4, height / 2 + 50 * ratio)
        
        visualizationSpectrumButton.fontName = "Helvetica Neue UltraLight"
        visualizationSpectrumButton.name = "visualizationSpectrumButton"
        visualizationSpectrumButton.fontSize = 32 * ratio
        visualizationSpectrumButton.position = CGPointMake(width / 3 * 2, height / 2 + 50 * ratio)
        
        visualizationNoneButton.fontName = "Helvetica Neue UltraLight"
        visualizationNoneButton.name = "visualizationNoneButton"
        visualizationNoneButton.fontSize = 32 * ratio
        visualizationNoneButton.position = CGPointMake(width / 8 * 7, height / 2 + 50 * ratio)
        
        lrcLabel.fontName = "Helvetica Neue UltraLight"
        lrcLabel.name = "lrcLabel"
        lrcLabel.fontSize = 32 * ratio
        lrcLabel.position = CGPointMake(width / 4, height / 2 - lrcLabel.frame.height - 50 * ratio)
        
        lrcYesButton.fontName = "Helvetica Neue UltraLight"
        lrcYesButton.name = "lrcYesButton"
        lrcYesButton.fontSize = 32 * ratio
        lrcYesButton.position = CGPointMake(width / 3 * 2, height / 2 - lrcYesButton.frame.height - 50 * ratio)
        
        lrcNoButton.fontName = "Helvetica Neue UltraLight"
        lrcNoButton.name = "lrcNoButton"
        lrcNoButton.fontSize = 32 * ratio
        lrcNoButton.position = CGPointMake(width / 8 * 7, height / 2 - lrcYesButton.frame.height - 50 * ratio)
        
        let SpectrumIndicatorRect = CGRectMake(visualizationSpectrumButton.position.x - visualizationSpectrumButton.frame.width / 2 - 5 * ratio, visualizationSpectrumButton.position.y - visualizationSpectrumButton.frame.height / 2 + 5 * ratio, visualizationSpectrumButton.frame.width + 10 * ratio, visualizationSpectrumButton.frame.height + 10 * ratio)
        let NoneIndicatorRect = CGRectMake(visualizationNoneButton.position.x - visualizationNoneButton.frame.width / 2 - 5 * ratio, visualizationNoneButton.position.y - visualizationNoneButton.frame.height / 2 + 5 * ratio, visualizationNoneButton.frame.width + 10 * ratio, visualizationSpectrumButton.frame.height + 10 * ratio)
        visualizationIndicator[0] = SKShapeNode(rect: SpectrumIndicatorRect, cornerRadius: 5)
        visualizationIndicator[1] = SKShapeNode(rect: NoneIndicatorRect, cornerRadius: 5)
        visualizationIndicator[0].name = "visualizationIndicatorSpectrum"
        visualizationIndicator[1].name = "visualizationIndicatorNone"
        for indicator in visualizationIndicator {
            indicator.strokeColor = SKColor.clearColor()
            indicator.fillColor = SKColor.whiteColor()
            indicator.alpha = 0.2
        }
        
        let YesIndicatorRect = CGRectMake(lrcYesButton.position.x - lrcYesButton.frame.width / 2 - 5 * ratio, lrcYesButton.position.y - lrcYesButton.frame.height / 2 + 5 * ratio, lrcYesButton.frame.width + 10 * ratio, lrcYesButton.frame.height + 15 * ratio)
        let NoIndicatorRect = CGRectMake(lrcNoButton.position.x - lrcNoButton.frame.width / 2 - 5 * ratio, lrcNoButton.position.y - lrcNoButton.frame.height / 2 + 5 * ratio, lrcNoButton.frame.width + 10 * ratio, lrcNoButton.frame.height + 15 * ratio)
        lrcIndicator[0] = SKShapeNode(rect: YesIndicatorRect, cornerRadius: 5)
        lrcIndicator[1] = SKShapeNode(rect: NoIndicatorRect, cornerRadius: 5)
        lrcIndicator[0].name = "lrcIndicatorYes"
        lrcIndicator[1].name = "lrcIndicatorNo"
        for indicator in lrcIndicator {
            indicator.strokeColor = SKColor.clearColor()
            indicator.fillColor = SKColor.whiteColor()
            indicator.alpha = 0.2
        }
        
        switch visualizationType {
        case visualization.Spectrum:
            addChild(visualizationIndicator[0])
        case visualization.None:
            addChild(visualizationIndicator[1])
        }
        
        if showLrc {
            addChild(lrcIndicator[0])
        } else {
            addChild(lrcIndicator[1])
        }
        
        Background = background.copy() as! SKSpriteNode
        addChild(Background)
        addChild(backButton)
        addChild(visualizationLabel)
        addChild(visualizationSpectrumButton)
        addChild(visualizationNoneButton)
        addChild(lrcLabel)
        addChild(lrcYesButton)
        addChild(lrcNoButton)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            
            // SKScene跳转
            if node.name != nil {
                switch node.name!{
                case  "backButton":
                    SaveSetting()
                    Scene = StartUpScene(size : CGSizeMake(width, height))
                    View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                case  "visualizationSpectrumButton":
                    if visualizationType != visualization.Spectrum {
                        for indicator in visualizationIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        visualizationIndicator[0].removeAllActions()
                        visualizationIndicator[0].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(visualizationIndicator[0])
                        visualizationType = visualization.Spectrum
                        settings["Visualization"] = "Spectrum"
                    }
                case  "visualizationNoneButton":
                    if visualizationType != visualization.None {
                        for indicator in visualizationIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        visualizationIndicator[1].removeAllActions()
                        visualizationIndicator[1].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(visualizationIndicator[1])
                        visualizationType = visualization.None
                        settings["Visualization"] = "None"
                    }
                case  "lrcYesButton":
                    if !showLrc {
                        for indicator in lrcIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        lrcIndicator[0].removeAllActions()
                        lrcIndicator[0].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(lrcIndicator[0])
                        showLrc = true
                        settings["LRC"] = "Yes"
                    }
                case  "lrcNoButton":
                    if showLrc {
                        for indicator in lrcIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        lrcIndicator[1].removeAllActions()
                        lrcIndicator[1].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(lrcIndicator[1])
                        showLrc = false
                        settings["LRC"] = "No"
                    }
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

