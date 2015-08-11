//
//  WaveCurve.swift
//  UntitledMusicGame
//
//  Created by 舒润萱 on 15/7/24.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WaveCurve: SKShapeNode {
    var data = [CGFloat]()
    
    convenience init(dataNum: Int) {
        self.init()
        data.reserveCapacity(dataNum)
        for var i: Int = 0; i < dataNum; ++i { data.append(CGFloat(0.0)) }
        let path = CGPathCreateMutable()
        
        //self.setScale(0.5)
        self.alpha = 0.05
        //CGPathAddEllipseInRect(path, nil, CGRect(origin: CGPoint(x: -radius / 2, y: -radius / 2), size: CGSize(width: radius, height: radius)))
        
        CGPathMoveToPoint(path, nil, 0, height / 2)
        CGPathAddLineToPoint(path, nil, width, height / 2)
        self.path = path
        self.zPosition = -500
        self.glowWidth = 1
        self.lineWidth = 3
        self.antialiased = true
        
    }
    
    func setCurveData(Data: [Double]) {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, (CGFloat(Data[0]) / 32768.0) * height * 0.2 + height / 2.0)
        let c = Data.count
        for var d: Int = 1; d < c; ++d {
            if d % 1 == 0 {
                CGPathAddLineToPoint(path, nil, width / CGFloat(c - 1) * CGFloat(d), (CGFloat(Data[d]) / 32768.0) * height * 0.2 + height / 2.0)
            }
        }
        self.path = path
    }
}