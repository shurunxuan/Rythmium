//
// Created by 舒润萱 on 15/4/28.
// Copyright (c) 2015 SRX. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Note: SKShapeNode {
    var NoteSize: CGFloat = 0
    var Time: Double = 0
    static var ID: Int = 0
    
    convenience init(time: Double, center : CGPoint, radius : CGFloat = 10) {
        
        let path = CGMutablePath()
        self.init()
        NoteSize = radius
        Time = time
        self.setScale(0.5)
        self.alpha = 0
        self.position = center
        //var transform = CGAffineTransform.identity
        let rect = CGRect.init(origin: CGPoint(x: -radius / 2, y: -radius / 2), size: CGSize(width: radius, height: radius))
        path.addEllipse(in: rect)
        //CGPathAddEllipseInRect(path, &transform, CGRect(origin: CGPoint(x: -radius / 2, y: -radius / 2), size: CGSize(width: radius, height: radius)))
        self.path = path
        self.glowWidth = 0
        self.lineWidth = 4.0
        self.strokeColor = brightColorWithHue(CGFloat(arc4random_uniform(360)) / 360.0)
        self.isAntialiased = true
        
    }
}

func brightColorWithHue(_ hue: CGFloat) -> UIColor {
    if colorfulTheme
    { return UIColor.init(hue: hue, saturation: 0.15, brightness: 1, alpha: 1) }
    else
    { return UIColor.white }
}
