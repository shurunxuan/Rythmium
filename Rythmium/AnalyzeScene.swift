//
//  AnalyzeScene.swift
//  UntitledMusicGame
//
//  Created by 舒润萱 on 15/7/7.
//  Copyright © 2015年 舒润萱. All rights reserved.
//


import SpriteKit
import Accelerate

class AnalyzeScene: SKScene {
    
    
    var analyzingLabels = [SKLabelNode(text: "Analyzing, please wait..."), SKLabelNode(text: "This may take a few seconds")]
    
    
    
    var needFFT = false
    
    var CafFile = FileClass()
    
    
    var Init = true
    var startTime: Double = 0.0
    
    var state = 0
    
    var notExported = true
    
    var Background = SKSpriteNode()
    
    var touch_particle: [Int : SKEmitterNode] = [:]
    
    override func didMoveToView(view: SKView) {
        Stage = GameStage.Analyze
        self.view?.multipleTouchEnabled = true
        
        for label in analyzingLabels {
            label.fontName = "SFUIDisplay-Ultralight"
            label.fontSize = 40 * ratio
        }
        analyzingLabels[0].position = CGPointMake(width / 2, height / 2)
        analyzingLabels[1].position = CGPointMake(width / 2, height / 2 - analyzingLabels[1].frame.height)
        
        Background = backgroundDark.copy() as! SKSpriteNode
        self.addChild(Background)
        
        needFFT = !FileClass.isExist(String(exporter.songID())+".mss")
        
        self.addChild(analyzingLabels[0])
        if !needFFT {
            analyzingLabels[0].text = "LOADING..."
            analyzingLabels[0].position = CGPointMake(width / 2, height / 2 - analyzingLabels[0].frame.height / 2)
        } else {
            self.addChild(analyzingLabels[1])
        }
        
        for label in analyzingLabels {
            label.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeOutWithDuration(1), SKAction.fadeInWithDuration(1)])))
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            if self.needFFT || visualizationType != visualization.None {
                if !restarted {
                    exporter.Export()
                    Left.removeAll()
                    self.CafFile.OpenFile("export-pcm.caf")
                    self.CafFile.Peek(4088)
                    let fileLength1 = 256 * 256 * 256 * self.CafFile.ReadBinary(1) + 256 * 256 * self.CafFile.ReadBinary(1)
                    let fileLength2 = 256 * self.CafFile.ReadBinary(1) + self.CafFile.ReadBinary(1) + 4092
                    let fileLength = fileLength1 + fileLength2
                    self.CafFile.Peek(4096)
                    
                    Left.reserveCapacity(fileLength / 4)
                    while self.CafFile.OFFSET() != fileLength {
                        let d : Int16 = self.CafFile.ReadBinary()
                        self.CafFile.Peek(self.CafFile.OFFSET() + 2)
                        Left.append(d)
                    }
                    
                    
                    if self.needFFT {
                        self.FFT(String(exporter.songID())+".mss", fileLength: fileLength)
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                Scene = GameScene(size : CGSizeMake(width, height))
                View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
            })
        })
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
            
            let particle = Particle.copy() as! SKEmitterNode
            particle.name = "particle" + String(touch.hash)
            particle.position = location
            particle.targetNode = self
            self.addChild(particle)
            touch_particle[touch.hash] = particle
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
    }
    
    
    
    
    
    
    func FFT(WriteFilePath: String, fileLength: Int) {
        
        var spec = [Double]()
        var sample = [Double]()
        var VU = [Double]()
        
        var spec_low = [Double]()
        var spec_mid = [Double]()
        var spec_high = [Double]()
        var spec_ehigh = [Double]()
        
        var VU_low = [Double]()
        var VU_mid = [Double]()
        var VU_high = [Double]()
        var VU_ehigh = [Double]()
        
        let nframes = (fileLength - 4096) / 4
        
        let FFTlength = 2940
        
        spec.reserveCapacity(nframes / FFTlength + 10)
        spec_low.reserveCapacity(nframes / FFTlength + 10)
        spec_mid.reserveCapacity(nframes / FFTlength + 10)
        spec_high.reserveCapacity(nframes / FFTlength + 10)
        spec_ehigh.reserveCapacity(nframes / FFTlength + 10)
        
        for var i: Int = 0; i < nframes; i += FFTlength {
            if i + FFTlength >= nframes { break }
            let block = Array(Left[i ..< i + 2048])
            var block_fft = fft(block)
            spec.append(sum(Array(block_fft)))
            spec_low.append(sum(Array(block_fft[0 ..< 64])))
            spec_mid.append(sum(Array(block_fft[64 ..< 192])))
            spec_high.append(sum(Array(block_fft[192 ..< 448])))
            spec_ehigh.append(sum(Array(block_fft[448 ..< 1024])))
            sample.append(Double(i) / 44100)
        }
        var Count = spec.count
        VU.reserveCapacity(Count + 1)
        VU_low.reserveCapacity(Count + 1)
        VU_mid.reserveCapacity(Count + 1)
        VU_high.reserveCapacity(Count + 1)
        VU_ehigh.reserveCapacity(Count + 1)
        
        for var i: Int = 0; i < Count; i++ {
            var sum: Double = 0
            var j: Int = 0;
            for j = 0; j < 256; j++ {
                if j + i < Count {
                    sum += Double(255 - j) * spec[j + i] } }
            VU.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
            sum = 0
            for j = 0; j < 256; j++ {
                if j + i < Count {
                    sum += Double(255 - j) * spec_low[j + i] } }
            VU_low.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
            sum = 0
            for j = 0; j < 256; j++ {
                if j + i < Count {
                    sum += Double(255 - j) * spec_mid[j + i] } }
            VU_mid.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
            sum = 0
            for j = 0; j < 256; j++ {
                if j + i < Count {
                    sum += Double(255 - j) * spec_high[j + i] } }
            VU_high.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
            sum = 0
            for j = 0; j < 256; j++ {
                if j + i < Count {
                    sum += Double(255 - j) * spec_ehigh[j + i] } }
            VU_ehigh.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
        }
        
        
        
        var i: Int = spec.count - 1
        while spec[i] < 100
        { i-- }
        Count = sample.count
        while sample[i] >= sample[Count - 1] - 30
        { i-- }
        Count = VU.count
        for var a: Int = i; a < Count; a++ {
            VU[a] = VU[i]
            VU_low[a] = VU_low[i]
            VU_mid[a] = VU_mid[i]
            VU_high[a] = VU_high[i]
            VU_ehigh[a] = VU_ehigh[i]
        }
        
        var sampleIncrease: Double = 0
        var sampleIncrease_low: Double = 0
        var sampleIncrease_mid: Double = 0
        var sampleIncrease_high: Double = 0
        var sampleIncrease_ehigh: Double = 0
        var notePointer: Int = 0
        var startTime: Double = 0
        let startTime_low: Double = 0
        let startTime_mid: Double = 0
        let startTime_high: Double = 0
        let startTime_ehigh: Double = 0
        var interval: Double = 0
        
        var timeList = [[Double](), [Double](), [Double](), [Double](), [Double]()]
        var timeListFirstElementStrength = [Double]()
        for var i: Int = 0; i < 5; ++i {
            timeList[i].reserveCapacity(500)
            timeList[i].append(0)
        }
        timeListFirstElementStrength.reserveCapacity(500)
        timeListFirstElementStrength.append(0)
        
        let WriteFile = FileClass()
        WriteFile.OpenFile(WriteFilePath)
        
        Count = sample.count
        
        
        
        for var i: Int = 1; i < Count - 1; i++ {
            if spec[i + 1] > spec[i]
            { sampleIncrease += spec[i + 1] - spec[i] }
            else {
                interval = sample[i + 1] - startTime
                if interval >= 0.1 {
                    
                    startTime = sample[i]
                    //notePointer++
                    timeList[0].append(sample[i])
                    timeList[1].append(0)
                    timeList[2].append(0)
                    timeList[3].append(0)
                    timeList[4].append(0)
                    timeListFirstElementStrength.append(sampleIncrease / VU[i])
                    
                }
                sampleIncrease = 0
            }
        }
        
        for var i: Int = 1; i < Count - 1; ++i {
            
            
            if spec_low[i + 1] > spec_low[i]
            { sampleIncrease_low += spec_low[i + 1] - spec_low[i] }
            else {
                interval = sample[i + 1] - startTime_low
                if interval >= 0.1 {
                    if notePointer >= timeList[0].count { notePointer = timeList[0].count - 1 }
                    while timeList[0][notePointer] < sample[i] && notePointer < timeList[0].count - 1 {
                        ++notePointer
                    }
                    while timeList[0][notePointer - 1] >= sample[i] && notePointer > 0 {
                        --notePointer
                    }
                    if sample[i] - timeList[0][notePointer - 1] < timeList[0][notePointer] - sample[i] {
                        --notePointer
                    }
                    if abs(sample[i] - timeList[0][notePointer]) < 0.1 {
                        timeList[1][notePointer] = sampleIncrease_low / VU_low[i]
                    }
                }
                sampleIncrease_low = 0
            }
            
            if spec_mid[i + 1] > spec_mid[i]
            { sampleIncrease_mid += spec_mid[i + 1] - spec_mid[i] }
            else {
                interval = sample[i + 1] - startTime_mid
                if interval >= 0.1 {
                    if notePointer >= timeList[0].count { notePointer = timeList[0].count - 1 }
                    while timeList[0][notePointer] < sample[i] && notePointer < timeList[0].count - 1 {
                        ++notePointer
                    }
                    while timeList[0][notePointer - 1] >= sample[i] && notePointer > 0 {
                        --notePointer
                    }
                    if sample[i] - timeList[0][notePointer - 1] < timeList[0][notePointer] - sample[i] {
                        --notePointer
                    }
                    if abs(sample[i] - timeList[0][notePointer]) < 0.1 {
                        timeList[2][notePointer] = sampleIncrease_mid / VU_mid[i]
                    }
                }
                sampleIncrease_mid = 0
            }
            
            if spec_high[i + 1] > spec_high[i]
            { sampleIncrease_high += spec_high[i + 1] - spec_high[i] }
            else {
                interval = sample[i + 1] - startTime_high
                if interval >= 0.1 {
                    if notePointer >= timeList[0].count { notePointer = timeList[0].count - 1 }
                    while timeList[0][notePointer] < sample[i] && notePointer < timeList[0].count - 1 {
                        ++notePointer
                    }
                    while timeList[0][notePointer - 1] >= sample[i] && notePointer > 0 {
                        --notePointer
                    }
                    if sample[i] - timeList[0][notePointer - 1] < timeList[0][notePointer] - sample[i] {
                        --notePointer
                    }
                    if abs(sample[i] - timeList[0][notePointer]) < 0.1 {
                        timeList[3][notePointer] = sampleIncrease_high / VU_high[i] / 1.8
                    }
                }
                sampleIncrease_high = 0
            }
            
            if spec_ehigh[i + 1] > spec_ehigh[i]
            { sampleIncrease_ehigh += spec_ehigh[i + 1] - spec_ehigh[i] }
            else {
                interval = sample[i + 1] - startTime_ehigh
                if interval >= 0.1 {
                    if notePointer >= timeList[0].count { notePointer = timeList[0].count - 1 }
                    while timeList[0][notePointer] < sample[i] && notePointer < timeList[0].count - 1 {
                        ++notePointer
                    }
                    while timeList[0][notePointer - 1] >= sample[i] && notePointer > 0 {
                        --notePointer
                    }
                    if sample[i] - timeList[0][notePointer - 1] < timeList[0][notePointer] - sample[i] {
                        --notePointer
                    }
                    if abs(sample[i] - timeList[0][notePointer]) < 0.1 {
                        timeList[4][notePointer] = sampleIncrease_ehigh / VU_ehigh[i] / 2.5
                    }
                }
                sampleIncrease_ehigh = 0
            }
        }
        
        
        var writeString: String = ""
        let count = timeList[0].count
        for var i: Int = 0; i < count; i++ {
            if timeListFirstElementStrength[i] > 0.1 || i == 0 {
                writeString += (String(timeListFirstElementStrength[i]) + "\t" + String(timeList[0][i]) + "\t" + String(timeList[1][i]) + "\t" + String(timeList[2][i]) + "\t" + String(timeList[3][i]) + "\t" + String(timeList[4][i]) + "\n")
            }
        }
        
        WriteFile.Write(writeString)
        
        //CafFile.DeleteFile()
        CafFile.OpenFile("export.m4a")
        CafFile.DeleteFile()
        
    }
}

