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
    
    override func didMove(to view: SKView) {
        Stage = GameStage.analyze
        self.view?.isMultipleTouchEnabled = true
        
        for label in analyzingLabels {
            label.fontName = "SFUIDisplay-Ultralight"
            label.fontSize = 40 * ratio
        }
        analyzingLabels[0].position = CGPoint(x: width / 2, y: height / 2)
        analyzingLabels[1].position = CGPoint(x: width / 2, y: height / 2 - analyzingLabels[1].frame.height)
        
        Background = backgroundDark.copy() as! SKSpriteNode
        self.addChild(Background)
        
        needFFT = !FileClass.isExist(String(exporter.songID())+".mss")
        
        self.addChild(analyzingLabels[0])
        if !needFFT {
            analyzingLabels[0].text = "LOADING..."
            analyzingLabels[0].position = CGPoint(x: width / 2, y: height / 2 - analyzingLabels[0].frame.height / 2)
        } else {
            self.addChild(analyzingLabels[1])
        }
        
        for label in analyzingLabels {
            label.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.fadeIn(withDuration: 1)])))
        }
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: {
            
            if self.needFFT || visualizationType != visualization.none {
                if !restarted {
                    exporter.export()
                    Left.removeAll()
                    self.CafFile.openFile("export-pcm.caf")
                    self.CafFile.peek(4088)
                    let fileLength1 = 256 * 256 * 256 * self.CafFile.readBinary(1) + 256 * 256 * self.CafFile.readBinary(1)
                    let fileLength2 = 256 * self.CafFile.readBinary(1) + self.CafFile.readBinary(1) + 4092
                    let fileLength = fileLength1 + fileLength2
                    self.CafFile.peek(4096)
                    
                    Left.reserveCapacity(fileLength / 4)
                    while self.CafFile.offset() != fileLength {
                        let d : Int16 = self.CafFile.readBinary()
                        self.CafFile.peek(self.CafFile.offset() + 2)
                        Left.append(d)
                    }
                    
                    
                    if self.needFFT {
                        self.FFT(String(exporter.songID())+".mss", fileLength: fileLength)
                    }
                }
            }
            
            DispatchQueue.main.async(execute: {
                Scene = GameScene(size : CGSize(width: width, height: height))
                View.presentScene(Scene, transition: SKTransition.crossFade(withDuration: 0.5))
            })
        })
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
            
            let particle = Particle.copy() as! SKEmitterNode
            particle.name = "particle" + String(touch.hash)
            particle.position = location
            particle.targetNode = self
            self.addChild(particle)
            touch_particle[touch.hash] = particle
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        
    }
    
    
    
    
    
    
    func FFT(_ WriteFilePath: String, fileLength: Int) {
        
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
        
        for var k in 0 ..< nframes / FFTlength {
            var i = k * FFTlength
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
        
        for i: Int in 0 ..< Count {
            var sum: Double = 0
            var j: Int = 0;
            for j in 0 ..< 256 {
                if j + i < Count {
                    sum += Double(255 - j) * spec[j + i] } }
            VU.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
            sum = 0
            for j in 0 ..< 256 {
                if j + i < Count {
                    sum += Double(255 - j) * spec_low[j + i] } }
            VU_low.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
            sum = 0
            for j in 0 ..< 256 {
                if j + i < Count {
                    sum += Double(255 - j) * spec_mid[j + i] } }
            VU_mid.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
            sum = 0
            for j in 0 ..< 256 {
                if j + i < Count {
                    sum += Double(255 - j) * spec_high[j + i] } }
            VU_high.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
            sum = 0
            for j in 0 ..< 256 {
                if j + i < Count {
                    sum += Double(255 - j) * spec_ehigh[j + i] } }
            VU_ehigh.append(2 * sum / ((510.0 - Double(j)) * (Double(j) + 1.0)))
        }
        
        
        
        var i: Int = spec.count - 1
        while spec[i] < 100
        { i -= 1 }
        Count = sample.count
        while sample[i] >= sample[Count - 1] - 30
        { i -= 1 }
        Count = VU.count
        for a: Int in i ..< Count {
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
        for i: Int in 0 ..< 5 {
            timeList[i].reserveCapacity(500)
            timeList[i].append(0)
        }
        timeListFirstElementStrength.reserveCapacity(500)
        timeListFirstElementStrength.append(0)
        
        let WriteFile = FileClass()
        WriteFile.openFile(WriteFilePath)
        
        Count = sample.count
        
        
        
        for i: Int in 1 ..< Count - 1 {
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
        
        for i: Int in 1 ..< Count - 1 {
            
            
            if spec_low[i + 1] > spec_low[i]
            { sampleIncrease_low += spec_low[i + 1] - spec_low[i] }
            else {
                interval = sample[i + 1] - startTime_low
                if interval >= 0.1 {
                    if notePointer >= timeList[0].count { notePointer = timeList[0].count - 1 }
                    while timeList[0][notePointer] < sample[i] && notePointer < timeList[0].count - 1 {
                        notePointer += 1
                    }
                    while timeList[0][notePointer - 1] >= sample[i] && notePointer > 0 {
                        notePointer -= 1
                    }
                    if sample[i] - timeList[0][notePointer - 1] < timeList[0][notePointer] - sample[i] {
                        notePointer -= 1
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
                        notePointer += 1
                    }
                    while timeList[0][notePointer - 1] >= sample[i] && notePointer > 0 {
                        notePointer -= 1
                    }
                    if sample[i] - timeList[0][notePointer - 1] < timeList[0][notePointer] - sample[i] {
                        notePointer -= 1
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
                        notePointer += 1
                    }
                    while timeList[0][notePointer - 1] >= sample[i] && notePointer > 0 {
                        notePointer -= 1
                    }
                    if sample[i] - timeList[0][notePointer - 1] < timeList[0][notePointer] - sample[i] {
                        notePointer -= 1
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
                        notePointer += 1
                    }
                    while timeList[0][notePointer - 1] >= sample[i] && notePointer > 0 {
                        notePointer -= 1
                    }
                    if sample[i] - timeList[0][notePointer - 1] < timeList[0][notePointer] - sample[i] {
                        notePointer -= 1
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
        for i: Int in 0 ..< count {
            if timeListFirstElementStrength[i] > 0.1 || i == 0 {
                writeString += (String(timeListFirstElementStrength[i]) + "\t" + String(timeList[0][i]) + "\t" + String(timeList[1][i]) + "\t" + String(timeList[2][i]) + "\t" + String(timeList[3][i]) + "\t" + String(timeList[4][i]) + "\n")
            }
        }
        
        WriteFile.write(writeString)
        
        //CafFile.DeleteFile()
        CafFile.openFile("export.m4a")
        CafFile.deleteFile()
        
    }
}

