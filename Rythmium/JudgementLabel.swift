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


class JudgementLabel : SKNode {
    var judge: Int = 0
    let act = SKAction.sequence([
        SKAction.group([SKAction.scale(to: 1.0, duration: 0.1), SKAction.fadeAlpha(to: 1.0, duration: 0.1)]),
        SKAction.wait(forDuration: 0.3),
        SKAction.group([SKAction.scale(to: 0.5, duration: 0.1), SKAction.fadeAlpha(to: 0.0, duration: 0.1)]),
        SKAction.removeFromParent()
        ])

    var score: Int = 0
    
    convenience init(combo: inout Int, HitTime: Double, NoteTime: Double) {
        self.init()
        self.name = "JudgementLabel"
        self.setScale(0.5)
        //self.alpha = 0.0
        //self.fontName = "Helvetica Neue Light"
        //self.fontSize = 40
        //self.zRotation = CGFloat(M_PI / 4)
        let TimeDifference = abs(HitTime - NoteTime)
        
        var label: SKSpriteNode

        if TimeDifference < 0.06 { label = SKSpriteNode(imageNamed: "PERFECT"); judge = 4; score = 1000 }

        else if TimeDifference < 0.12 { label = SKSpriteNode(imageNamed: "COOL"); judge = 3; score = 800 }

        else if TimeDifference < 0.16 { label = SKSpriteNode(imageNamed: "FINE"); judge = 2; score = 400 }

        else if TimeDifference < 0.20 { label = SKSpriteNode(imageNamed: "BAD"); judge = 1; score = 0 }

        else { label = SKSpriteNode(imageNamed: "MISS"); judge = 0; score = -100 }
        label.setScale(0.3 * ratio)
        
        if judge > 2 {
            combo += 1
            if combo > maxCombo { maxCombo = combo }
        } else {
            combo = 0
            fullCombo = false
        }
        if combo <= 5 { label.position = CGPoint(x: 0, y: 0) }
        else {
            let str = String(combo)
            var strPrefix: String = ""
            if judge == 3 { strPrefix = "c" }
            else if judge == 4 { strPrefix = "p" }
            var maxWidth : CGFloat = 0
            var numbers = [SKSpriteNode]()
            for i: Int in 0 ..< str.characters.count {
                let number = SKSpriteNode(imageNamed: strPrefix + String(str[i]))
                number.setScale(label.frame.height / number.frame.height * 1.5)
                if number.frame.width > maxWidth { maxWidth = number.frame.width }
                numbers.append(number)
            }
            for i: Int in 0 ..< numbers.count {
                numbers[i].position = CGPoint(x: (CGFloat(i) - CGFloat(str.characters.count - 1) / 2.0) * maxWidth, y: -numbers[i].frame.height / 2 - 4 * ratio)
                self.addChild(numbers[i])
            }
            label.position = CGPoint(x: 0, y: label.frame.height / 2 + 4 * ratio)
        }

        self.position = CGPoint(x: width / 2, y: height / 2)
        self.addChild(label)
    }
    
    func runAction() {
        self.run(act)
    }
    
    
}

