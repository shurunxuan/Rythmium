//
//  JudgementLabel.swift
//  MusicGame
//
//  Created by 舒润萱 on 15/5/19.
//  Copyright (c) 2015年 SRX. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class JudgementLabel : SKSpriteNode {
    var judge: Int = 0
    let act = SKAction.sequence([
        SKAction.group([SKAction.scaleTo(1.0, duration: 0.1), SKAction.fadeAlphaTo(1.0, duration: 0.1)]),
        SKAction.waitForDuration(0.3),
        SKAction.group([SKAction.scaleTo(0.5, duration: 0.1), SKAction.fadeAlphaTo(0.0, duration: 0.1)]),
        SKAction.removeFromParent()
        ])

    var score: Int = 0
    
    convenience init(type: Int, HitTime: Double, NoteTime: Double) {
        self.init()
        self.name = "JudgementLabel"
        self.setScale(0.5)
        //self.alpha = 0.0
        //self.fontName = "Helvetica Neue Light"
        //self.fontSize = 40
        //self.zRotation = CGFloat(M_PI / 4)
        let TimeDifference = abs(HitTime - NoteTime)

        if TimeDifference < 0.08 { self.texture = SKTexture(imageNamed: "PERFECT"); judge = 4; score = 1000 }

        else if TimeDifference < 0.16 { self.texture = SKTexture(imageNamed: "COOL"); judge = 3; score = 800 }

        else if TimeDifference < 0.24 { self.texture = SKTexture(imageNamed: "FINE"); judge = 2; score = 400 }

        else if TimeDifference < 0.30 { self.texture = SKTexture(imageNamed: "BAD"); judge = 1; score = 0 }

        else { self.texture = SKTexture(imageNamed: "MISS"); judge = 0; score = -100 }

        self.size = CGSizeMake(70 * ratio, 18.63905325443787 * ratio)
        self.position = CGPointMake(width / 2, height / 2)
        /*switch type {
        case 0:
            self.position = CGPointMake(CGFloat(width / 4 * 3 + difference), CGFloat(height / 4 * 3 - difference))
        case 1:
            self.position = CGPointMake(CGFloat(width / 4 + difference), CGFloat(height / 4 * 3 - difference))
        case 2:
            self.position = CGPointMake(CGFloat(width / 4 + difference), CGFloat(height / 4 - difference))
        case 3:
            self.position = CGPointMake(CGFloat(width / 4 * 3 + difference), CGFloat(height / 4 - difference))
        default:
            break
        }*/
    }
    
    func runAction() {
        self.runAction(act)
    }
    
    
}

