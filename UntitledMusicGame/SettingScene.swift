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
    
    
    override func didMoveToView(view: SKView) {
        
        Stage = GameStage.Setting
        
        backButton.fontName = "Helvetica Neue UltraLight"
        backButton.name = "backButton"
        backButton.fontSize = 32 * ratio
        backButton.position = CGPointMake(width / 8, height / 8 - backButton.frame.height / 2)
        
        visualizationLabel.fontName = "Helvetica Neue UltraLight"
        visualizationLabel.name = "visualizationLabel"
        visualizationLabel.fontSize = 32 * ratio
        visualizationLabel.position = CGPointMake(width / 4, height / 2 - visualizationLabel.frame.height / 2)
        
        visualizationSpectrumButton.fontName = "Helvetica Neue UltraLight"
        visualizationSpectrumButton.name = "visualizationSpectrumButton"
        visualizationSpectrumButton.fontSize = 32 * ratio
        visualizationSpectrumButton.position = CGPointMake(width / 3 * 2, height / 2 - visualizationSpectrumButton.frame.height / 2)
        
        visualizationNoneButton.fontName = "Helvetica Neue UltraLight"
        visualizationNoneButton.name = "visualizationNoneButton"
        visualizationNoneButton.fontSize = 32 * ratio
        visualizationNoneButton.position = CGPointMake(width / 8 * 7, height / 2 - visualizationNoneButton.frame.height / 2)
        
        visualizationIndicator[0] = SKShapeNode(rect: visualizationSpectrumButton.frame, cornerRadius: 5)
        visualizationIndicator[1] = SKShapeNode(rect: visualizationNoneButton.frame, cornerRadius: 5)
        visualizationIndicator[0].name = "visualizationIndicatorSpectrum"
        visualizationIndicator[1].name = "visualizationIndicatorNone"
        for indicator in visualizationIndicator {
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
        
        addChild(backButton)
        addChild(visualizationLabel)
        addChild(visualizationSpectrumButton)
        addChild(visualizationNoneButton)
        
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

