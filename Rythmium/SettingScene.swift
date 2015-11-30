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
    
    var colorfulThemeLabel = SKLabelNode(text: "Colorful Theme")
    var colorfulThemeOnButton = SKLabelNode(text: "On")
    var colorfulThemeOffButton = SKLabelNode(text: "Off")
    var colorfulThemeIndicator = [SKShapeNode(), SKShapeNode()]
    
    var Background = SKSpriteNode()
    
    var touch_particle: [Int : SKEmitterNode] = [:]
    

    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.Setting
        
        backButton.fontName = "SFUIDisplay-Ultralight"
        backButton.name = "backButton"
        backButton.fontSize = 32 * ratio
        backButton.position = CGPointMake(width / 8, height / 8 - backButton.frame.height / 2)
        
        visualizationLabel.fontName = "SFUIDisplay-Ultralight"
        visualizationLabel.name = "visualizationLabel"
        visualizationLabel.fontSize = 32 * ratio
        visualizationLabel.position = CGPointMake(width / 4, height / 2 + 50 * ratio)
        
        visualizationSpectrumButton.fontName = "SFUIDisplay-Ultralight"
        visualizationSpectrumButton.name = "visualizationSpectrumButton"
        visualizationSpectrumButton.fontSize = 32 * ratio
        visualizationSpectrumButton.position = CGPointMake(width / 3 * 2, height / 2 + 50 * ratio)
        
        visualizationNoneButton.fontName = "SFUIDisplay-Ultralight"
        visualizationNoneButton.name = "visualizationNoneButton"
        visualizationNoneButton.fontSize = 32 * ratio
        visualizationNoneButton.position = CGPointMake(width / 8 * 7, height / 2 + 50 * ratio)
        
        colorfulThemeLabel.fontName = "SFUIDisplay-Ultralight"
        colorfulThemeLabel.name = "colorfulThemeLabel"
        colorfulThemeLabel.fontSize = 32 * ratio
        colorfulThemeLabel.position = CGPointMake(width / 4, height / 2 - colorfulThemeLabel.frame.height - 50 * ratio)
        
        colorfulThemeOnButton.fontName = "SFUIDisplay-Ultralight"
        colorfulThemeOnButton.name = "colorfulThemeOnButton"
        colorfulThemeOnButton.fontSize = 32 * ratio
        colorfulThemeOnButton.position = CGPointMake(width / 3 * 2, height / 2 - colorfulThemeOnButton.frame.height - 50 * ratio)
        
        colorfulThemeOffButton.fontName = "SFUIDisplay-Ultralight"
        colorfulThemeOffButton.name = "colorfulThemeOffButton"
        colorfulThemeOffButton.fontSize = 32 * ratio
        colorfulThemeOffButton.position = CGPointMake(width / 8 * 7, height / 2 - colorfulThemeOnButton.frame.height - 50 * ratio)
        
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
        
        let OnIndicatorRect = CGRectMake(colorfulThemeOnButton.position.x - colorfulThemeOnButton.frame.width / 2 - 5 * ratio, colorfulThemeOnButton.position.y - colorfulThemeOnButton.frame.height / 2 + 5 * ratio, colorfulThemeOnButton.frame.width + 10 * ratio, colorfulThemeOnButton.frame.height + 15 * ratio)
        let NoIndicatorRect = CGRectMake(colorfulThemeOffButton.position.x - colorfulThemeOffButton.frame.width / 2 - 5 * ratio, colorfulThemeOffButton.position.y - colorfulThemeOffButton.frame.height / 2 + 5 * ratio, colorfulThemeOffButton.frame.width + 10 * ratio, colorfulThemeOffButton.frame.height + 15 * ratio)
        colorfulThemeIndicator[0] = SKShapeNode(rect: OnIndicatorRect, cornerRadius: 5)
        colorfulThemeIndicator[1] = SKShapeNode(rect: NoIndicatorRect, cornerRadius: 5)
        colorfulThemeIndicator[0].name = "colorfulThemeIndicatorOn"
        colorfulThemeIndicator[1].name = "colorfulThemeIndicatorOff"
        for indicator in colorfulThemeIndicator {
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
        
        if colorfulTheme {
            addChild(colorfulThemeIndicator[0])
        } else {
            addChild(colorfulThemeIndicator[1])
        }
        
        Background = background.copy() as! SKSpriteNode
        addChild(Background)
        addChild(backButton)
        addChild(visualizationLabel)
        addChild(visualizationSpectrumButton)
        addChild(visualizationNoneButton)
        addChild(colorfulThemeLabel)
        addChild(colorfulThemeOnButton)
        addChild(colorfulThemeOffButton)
        
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
                case  "colorfulThemeOnButton":
                    if !colorfulTheme {
                        for indicator in colorfulThemeIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        colorfulThemeIndicator[0].removeAllActions()
                        colorfulThemeIndicator[0].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(colorfulThemeIndicator[0])
                        colorfulTheme = true
                        settings["colorfulTheme"] = "On"
                    }
                case  "colorfulThemeOffButton":
                    if colorfulTheme {
                        for indicator in colorfulThemeIndicator {
                            indicator.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        colorfulThemeIndicator[1].removeAllActions()
                        colorfulThemeIndicator[1].runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                        addChild(colorfulThemeIndicator[1])
                        colorfulTheme = false
                        settings["colorfulTheme"] = "Off"
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

