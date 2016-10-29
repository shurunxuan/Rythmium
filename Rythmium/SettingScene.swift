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
    var visualizationSpectrumLabel = SKLabelNode(text: "Spectrum Type")
    var visualizationSpectrumNormalButton = SKLabelNode(text: "Normal")
    var visualizationSpectrumCircleButton = SKLabelNode(text: "Circle")
    var visualizationSpectrumIndicator = [SKShapeNode(), SKShapeNode()]
    
    var colorfulThemeLabel = SKLabelNode(text: "Colorful Theme")
    var colorfulThemeOnButton = SKLabelNode(text: "On")
    var colorfulThemeOffButton = SKLabelNode(text: "Off")
    var colorfulThemeIndicator = [SKShapeNode(), SKShapeNode()]
    
    var Background = SKSpriteNode()
    
    var touch_particle: [Int : SKEmitterNode] = [:]
    
    var heightOffset: CGFloat = 0
    
    
    override func didMove(to view: SKView) {
        
        Stage = GameStage.setting
        
        backButton.fontName = "SFUIDisplay-Ultralight"
        backButton.name = "backButton"
        backButton.fontSize = 32 * ratio
        backButton.position = CGPoint(x: width / 8, y: height / 8 - backButton.frame.height / 2)
        
        heightOffset = (backButton.position.y + backButton.frame.height) / 2.0
        
        visualizationLabel.fontName = "SFUIDisplay-Ultralight"
        visualizationLabel.name = "visualizationLabel"
        visualizationLabel.fontSize = 32 * ratio
        visualizationLabel.position = CGPoint(x: width / 4, y: height / 2 + heightOffset + 40 * ratio)
        
        visualizationSpectrumLabel.fontName = "SFUIDisplay-Ultralight"
        visualizationSpectrumLabel.name = "visualizationLabel"
        visualizationSpectrumLabel.fontSize = 32 * ratio
        visualizationSpectrumLabel.position = CGPoint(x: width / 4, y: height / 2 + heightOffset - visualizationSpectrumLabel.frame.height + 10 * ratio)
        
        visualizationSpectrumButton.fontName = "SFUIDisplay-Ultralight"
        visualizationSpectrumButton.name = "visualizationSpectrumButton"
        visualizationSpectrumButton.fontSize = 32 * ratio
        visualizationSpectrumButton.position = CGPoint(x: width / 3 * 2, y: height / 2 + heightOffset + 40 * ratio)
        
        visualizationSpectrumNormalButton.fontName = "SFUIDisplay-Ultralight"
        visualizationSpectrumNormalButton.name = "visualizationSpectrumNormalButton"
        visualizationSpectrumNormalButton.fontSize = 32 * ratio
        visualizationSpectrumNormalButton.position = CGPoint(x: width / 3 * 2, y: height / 2 + heightOffset - visualizationSpectrumLabel.frame.height + 10 * ratio)
        
        visualizationSpectrumCircleButton.fontName = "SFUIDisplay-Ultralight"
        visualizationSpectrumCircleButton.name = "visualizationSpectrumCircleButton"
        visualizationSpectrumCircleButton.fontSize = 32 * ratio
        visualizationSpectrumCircleButton.position = CGPoint(x: width / 8 * 7, y: height / 2 + heightOffset - visualizationSpectrumLabel.frame.height + 10 * ratio)
        
        visualizationNoneButton.fontName = "SFUIDisplay-Ultralight"
        visualizationNoneButton.name = "visualizationNoneButton"
        visualizationNoneButton.fontSize = 32 * ratio
        visualizationNoneButton.position = CGPoint(x: width / 8 * 7, y: height / 2 + heightOffset + 40 * ratio)
        
        colorfulThemeLabel.fontName = "SFUIDisplay-Ultralight"
        colorfulThemeLabel.name = "colorfulThemeLabel"
        colorfulThemeLabel.fontSize = 32 * ratio
        colorfulThemeLabel.position = CGPoint(x: width / 4, y: height / 2 + heightOffset - colorfulThemeLabel.frame.height - 60 * ratio)
        
        colorfulThemeOnButton.fontName = "SFUIDisplay-Ultralight"
        colorfulThemeOnButton.name = "colorfulThemeOnButton"
        colorfulThemeOnButton.fontSize = 32 * ratio
        colorfulThemeOnButton.position = CGPoint(x: width / 3 * 2, y: height / 2 + heightOffset - colorfulThemeOnButton.frame.height - 60 * ratio)
        
        colorfulThemeOffButton.fontName = "SFUIDisplay-Ultralight"
        colorfulThemeOffButton.name = "colorfulThemeOffButton"
        colorfulThemeOffButton.fontSize = 32 * ratio
        colorfulThemeOffButton.position = CGPoint(x: width / 8 * 7, y: height / 2 + heightOffset - colorfulThemeOnButton.frame.height - 60 * ratio)
        
        let SpectrumIndicatorRect = CGRect(x: visualizationSpectrumButton.position.x - visualizationSpectrumButton.frame.width / 2 - 5 * ratio, y: visualizationSpectrumButton.position.y - visualizationSpectrumButton.frame.height / 2 + 5 * ratio, width: visualizationSpectrumButton.frame.width + 10 * ratio, height: visualizationSpectrumButton.frame.height + 10 * ratio)
        let NoneIndicatorRect = CGRect(x: visualizationNoneButton.position.x - visualizationNoneButton.frame.width / 2 - 5 * ratio, y: visualizationNoneButton.position.y - visualizationNoneButton.frame.height / 2 + 5 * ratio, width: visualizationNoneButton.frame.width + 10 * ratio, height: visualizationSpectrumButton.frame.height + 10 * ratio)
        visualizationIndicator[0] = SKShapeNode(rect: SpectrumIndicatorRect, cornerRadius: 5)
        visualizationIndicator[1] = SKShapeNode(rect: NoneIndicatorRect, cornerRadius: 5)
        visualizationIndicator[0].name = "visualizationIndicatorSpectrum"
        visualizationIndicator[1].name = "visualizationIndicatorNone"
        for indicator in visualizationIndicator {
            indicator.strokeColor = SKColor.clear
            indicator.fillColor = SKColor.white
            indicator.alpha = 0.2
        }
        
        let SpectrumNormalIndicatorRect = CGRect(x: visualizationSpectrumNormalButton.position.x - visualizationSpectrumNormalButton.frame.width / 2 - 5 * ratio, y: visualizationSpectrumNormalButton.position.y - visualizationSpectrumNormalButton.frame.height / 2 + 5 * ratio, width: visualizationSpectrumNormalButton.frame.width + 10 * ratio, height: visualizationSpectrumNormalButton.frame.height + 15 * ratio)
        let SpectrumCircleIndicatorRect = CGRect(x: visualizationSpectrumCircleButton.position.x - visualizationSpectrumCircleButton.frame.width / 2 - 5 * ratio, y: visualizationSpectrumCircleButton.position.y - visualizationSpectrumCircleButton.frame.height / 2 + 5 * ratio, width: visualizationSpectrumCircleButton.frame.width + 10 * ratio, height: visualizationSpectrumNormalButton.frame.height + 15 * ratio)
        visualizationSpectrumIndicator[0] = SKShapeNode(rect: SpectrumNormalIndicatorRect, cornerRadius: 5)
        visualizationSpectrumIndicator[1] = SKShapeNode(rect: SpectrumCircleIndicatorRect, cornerRadius: 5)
        visualizationSpectrumIndicator[0].name = "visualizationIndicatorSpectrumNormal"
        visualizationSpectrumIndicator[1].name = "visualizationIndicatorSpectrumCircle"
        for indicator in visualizationSpectrumIndicator {
            indicator.strokeColor = SKColor.clear
            indicator.fillColor = SKColor.white
            indicator.alpha = 0.2
        }
        
        let OnIndicatorRect = CGRect(x: colorfulThemeOnButton.position.x - colorfulThemeOnButton.frame.width / 2 - 5 * ratio, y: colorfulThemeOnButton.position.y - colorfulThemeOnButton.frame.height / 2 + 5 * ratio, width: colorfulThemeOnButton.frame.width + 10 * ratio, height: colorfulThemeOnButton.frame.height + 15 * ratio)
        let NoIndicatorRect = CGRect(x: colorfulThemeOffButton.position.x - colorfulThemeOffButton.frame.width / 2 - 5 * ratio, y: colorfulThemeOffButton.position.y - colorfulThemeOffButton.frame.height / 2 + 5 * ratio, width: colorfulThemeOffButton.frame.width + 10 * ratio, height: colorfulThemeOffButton.frame.height + 15 * ratio)
        colorfulThemeIndicator[0] = SKShapeNode(rect: OnIndicatorRect, cornerRadius: 5)
        colorfulThemeIndicator[1] = SKShapeNode(rect: NoIndicatorRect, cornerRadius: 5)
        colorfulThemeIndicator[0].name = "colorfulThemeIndicatorOn"
        colorfulThemeIndicator[1].name = "colorfulThemeIndicatorOff"
        for indicator in colorfulThemeIndicator {
            indicator.strokeColor = SKColor.clear
            indicator.fillColor = SKColor.white
            indicator.alpha = 0.2
        }
        
        switch visualizationType {
        case visualization.spectrumNormal:
            addChild(visualizationSpectrumLabel)
            addChild(visualizationIndicator[0])
            addChild(visualizationSpectrumIndicator[0])
            addChild(visualizationSpectrumNormalButton)
            addChild(visualizationSpectrumCircleButton)
        case visualization.spectrumCircle:
            addChild(visualizationSpectrumLabel)
            addChild(visualizationIndicator[0])
            addChild(visualizationSpectrumIndicator[1])
            addChild(visualizationSpectrumNormalButton)
            addChild(visualizationSpectrumCircleButton)
        case visualization.none:
            addChild(visualizationIndicator[1])
        }
        
        if colorfulTheme {
            addChild(colorfulThemeIndicator[0])
        } else {
            addChild(colorfulThemeIndicator[1])
        }
        
        Background = backgroundDark.copy() as! SKSpriteNode
        addChild(Background)
        addChild(backButton)
        addChild(visualizationLabel)
        addChild(visualizationSpectrumButton)
        addChild(visualizationNoneButton)
        addChild(colorfulThemeLabel)
        addChild(colorfulThemeOnButton)
        addChild(colorfulThemeOffButton)
        
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
                switch node.name!{
                case  "backButton":
                    SaveSetting()
                    Scene = StartUpScene(size : CGSize(width: width, height: height))
                    View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
                case  "visualizationSpectrumButton":
                    if visualizationType != visualization.spectrumNormal && visualizationType != visualization.spectrumCircle {
                        for indicator in visualizationIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        visualizationIndicator[0].removeAllActions()
                        visualizationIndicator[0].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(visualizationIndicator[0])
                        visualizationSpectrumIndicator[0].removeAllActions()
                        visualizationSpectrumIndicator[0].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(visualizationSpectrumIndicator[0])
                        visualizationSpectrumLabel.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                        addChild(visualizationSpectrumLabel)
                        visualizationSpectrumNormalButton.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                        addChild(visualizationSpectrumNormalButton)
                        visualizationSpectrumCircleButton.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                        addChild(visualizationSpectrumCircleButton)
                        visualizationType = visualization.spectrumNormal
                        settings["Visualization"] = "SpectrumNormal"
                    }
                case  "visualizationSpectrumNormalButton":
                    if visualizationType != visualization.spectrumNormal {
                        for indicator in visualizationSpectrumIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        visualizationSpectrumIndicator[0].removeAllActions()
                        visualizationSpectrumIndicator[0].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(visualizationSpectrumIndicator[0])
                        visualizationType = visualization.spectrumNormal
                        settings["Visualization"] = "SpectrumCircle"
                    }
                case  "visualizationSpectrumCircleButton":
                    if visualizationType != visualization.spectrumCircle {
                        for indicator in visualizationSpectrumIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        visualizationSpectrumIndicator[1].removeAllActions()
                        visualizationSpectrumIndicator[1].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(visualizationSpectrumIndicator[1])
                        visualizationType = visualization.spectrumCircle
                        settings["Visualization"] = "SpectrumCircle"
                    }
                case  "visualizationNoneButton":
                    if visualizationType != visualization.none {
                        for indicator in visualizationIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        visualizationIndicator[1].removeAllActions()
                        visualizationIndicator[1].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(visualizationIndicator[1])
                        visualizationSpectrumLabel.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        visualizationSpectrumNormalButton.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        visualizationSpectrumCircleButton.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        visualizationSpectrumIndicator[0].run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        visualizationSpectrumIndicator[1].run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        visualizationType = visualization.none
                        settings["Visualization"] = "None"
                    }
                case  "colorfulThemeOnButton":
                    if !colorfulTheme {
                        for indicator in colorfulThemeIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        colorfulThemeIndicator[0].removeAllActions()
                        colorfulThemeIndicator[0].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                        addChild(colorfulThemeIndicator[0])
                        colorfulTheme = true
                        settings["colorfulTheme"] = "On"
                    }
                case  "colorfulThemeOffButton":
                    if colorfulTheme {
                        for indicator in colorfulThemeIndicator {
                            indicator.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.removeFromParent()]))
                        }
                        colorfulThemeIndicator[1].removeAllActions()
                        colorfulThemeIndicator[1].run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
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
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}

