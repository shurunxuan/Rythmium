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
    
    
    var analyzingLabels = [SKLabelNode(text: "Analyzing, please wait..."), SKLabelNode(text: "This may take a minute or longer")]
    
    
    
    var needFFT = false
    
    var CafFile = FileClass()
    
    
    var Init = true
    var startTime: Double = 0.0
    
    var state = -1
    
    var notExported = true
    
    var Background = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        Stage = GameStage.Analyze
        
        exporter.ChooseSong()
        for label in analyzingLabels {
            label.fontName = "Helvetica Neue UltraLight"
            label.fontSize = 40 * ratio
            label.alpha = 0
        }
        analyzingLabels[0].position = CGPointMake(width / 2, height / 2 + analyzingLabels[0].frame.height / 2)
        analyzingLabels[1].position = CGPointMake(width / 2, height / 2 - analyzingLabels[1].frame.height / 2)
        
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if exporter.isDone() {
            if exporter.isDismissed() {
                Scene = StartUpScene(size : CGSizeMake(width, height))
                View.presentScene(Scene, transition: SKTransition.crossFadeWithDuration(0.5))
                return
            }
            exporter.setEnd()
            needFFT = !FileClass.isExist(String(exporter.songID())+".mss")
            state = 0
            artViewBackground = exporter.Song().artwork
            //.imageWithSize(CGSize(width: 100, height: 100))
            if (artViewBackground != nil) {
                let backgroundWidth = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.width
                let backgroundHeight = artViewBackground?.imageWithSize(CGSizeMake(100, 100))!.size.height
                var size = CGSize()
                if (backgroundWidth! / backgroundHeight!) < (16.0 / 9.0) {
                    size = CGSizeMake(width, width / backgroundWidth! * backgroundHeight!)
                } else {
                    size = CGSizeMake(height / backgroundHeight! * backgroundWidth!, height)
                }
                background = SKSpriteNode(texture: SKTexture(image: exporter.Song().artwork!.resizedImage(size, interpolationQuality: CGInterpolationQuality.Low).applyDarkEffect()))
                //background.size = CGSize(width: 736, height: 414)
                background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                background.zPosition = -1000
                Background = background.copy() as! SKSpriteNode
                Background.alpha = 0
                Background.runAction(SKAction.sequence([SKAction.waitForDuration(0.5), staticNodesAppearAction]))
                
                self.addChild(Background)
                
            }
            
        }
        if state == 0 {
            if Init {
                Init = false
                startTime = Double(currentTime)
                self.addChild(analyzingLabels[0])
                if !needFFT {
                    analyzingLabels[0].text = "LOADING..."
                    analyzingLabels[0].position = CGPointMake(width / 2, height / 2 - analyzingLabels[0].frame.height / 2)
                } else {
                    self.addChild(analyzingLabels[1])
                }
                analyzingLabels[0].runAction(SKAction.sequence([SKAction.waitForDuration(0.5), staticNodesAppearAction]))
                analyzingLabels[1].runAction(SKAction.sequence([SKAction.waitForDuration(0.5), staticNodesAppearAction]))
            }
            
            if Double(currentTime) - startTime > 1 && Background.alpha > 0.95 {
                if needFFT || visualizationType != visualization.None {
                    exporter.Export()
                    Left.removeAll()
                    CafFile.OpenFile("export-pcm.caf")
                    CafFile.Peek(4088)
                    let fileLength = 256 * 256 * 256 * CafFile.ReadBinary(1) + 256 * 256 * CafFile.ReadBinary(1) +
                        256 * CafFile.ReadBinary(1) + CafFile.ReadBinary(1) + 4092
                    CafFile.Peek(4096)
                    
                    Left.reserveCapacity(fileLength / 4)
                    while CafFile.OFFSET() != fileLength {
                        var d = CafFile.ReadBinary()
                        CafFile.Peek(CafFile.OFFSET() + 2)
                        if d / 256 / 128 == 1 {
                            d -= 65536
                        }
                        Left.append(Double(d))
                    }
                    
                    if needFFT {
                        FFT(String(exporter.songID())+".mss", fileLength: fileLength)
                    }
                }
                for label in analyzingLabels {
                    label.runAction(SKAction.sequence([SKAction.waitForDuration(0.5), staticNodesDisappearAction]))
                }
                //needFFT = false
                state = 1
                Init = true
                
            }
        }
        if state == 1 {
            if Init {
                startTime = Double(currentTime)
                Init = false
            }
            if Double(currentTime) - startTime > 0.5 {
                Scene = GameScene(size : CGSizeMake(width, height))
                View.presentScene(Scene)//, transition: SKTransition.crossFadeWithDuration(0.5))
                background.removeFromParent()
            }
        }
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
        
        var sampleIncrease_low: Double = 0
        var sampleIncrease_mid: Double = 0
        var sampleIncrease_high: Double = 0
        var sampleIncrease_ehigh: Double = 0
        var notePointer: Int = 0
        var startTime_low: Double = 0
        var startTime_mid: Double = 0
        var startTime_high: Double = 0
        var startTime_ehigh: Double = 0
        var interval: Double = 0
        var numOfKeys: [Int] = [0, 0, 0, 0]
        
        var timeList = [[Int](), [Int]()]
        timeList[0].reserveCapacity(500)
        timeList[1].reserveCapacity(500)
        timeList[0].append(0)
        timeList[1].append(0)
        
        let WriteFile = FileClass()
        WriteFile.OpenFile(WriteFilePath)
        
        Count = sample.count
        for var i: Int = 1; i < Count - 1; i++ {
            if spec_low[i + 1] > spec_low[i]
            { sampleIncrease_low += spec_low[i + 1] - spec_low[i] }
            else {
                if sampleIncrease_low > VU_low[i] / 2.8 {
                    interval = sample[i + 1] - startTime_low
                    if interval >= 0.1 {
                        if sample[i] - Double(timeList[0][notePointer]) / 44100 > 0.1 {
                            startTime_low = sample[i]
                            notePointer++
                            timeList[0].append(Int(sample[i] * 44100))
                            timeList[1].append(0)
                            numOfKeys[0]++
                        } else if numOfKeys[0] < numOfKeys[timeList[1][notePointer]] {
                            numOfKeys[timeList[1][notePointer]]--
                            numOfKeys[0]++
                            timeList[1][notePointer] = 0
                        }/* else if timeList[2][notePointer] == 0 {
                        timeList[2][notePointer] = 1
                        numOfKeys[0]++
                        }*/
                    }
                }
                sampleIncrease_low = 0
            }
            
            if spec_mid[i + 1] > spec_mid[i]
            { sampleIncrease_mid += spec_mid[i + 1] - spec_mid[i] }
            else {
                if sampleIncrease_mid > VU_mid[i] / 1.5 {
                    interval = sample[i + 1] - startTime_mid
                    if interval >= 0.1 {
                        if sample[i] - Double(timeList[0][notePointer]) / 44100 > 0.1 {
                            startTime_mid = sample[i]
                            notePointer++
                            timeList[0].append(Int(sample[i] * 44100))
                            timeList[1].append(1)
                            numOfKeys[1]++
                        } else if numOfKeys[1] < numOfKeys[timeList[1][notePointer]] {
                            numOfKeys[timeList[1][notePointer]]--
                            numOfKeys[1]++
                            timeList[1][notePointer] = 1
                        }/* else if timeList[2][notePointer] == 0 {
                        timeList[2][notePointer] = 1
                        numOfKeys[0]++
                        }*/
                    }
                }
                sampleIncrease_mid = 0
            }
            
            if spec_high[i + 1] > spec_high[i]
            { sampleIncrease_high += spec_high[i + 1] - spec_high[i] }
            else {
                if sampleIncrease_high > VU_high[i] * 0.8 && sampleIncrease_high < 2 * VU_high[i] {
                    interval = sample[i + 1] - startTime_high
                    if interval >= 0.1 {
                        if sample[i] - Double(timeList[0][notePointer]) / 44100 > 0.1 {
                            startTime_high = sample[i]
                            notePointer++
                            timeList[0].append(Int(sample[i] * 44100))
                            timeList[1].append(2)
                            numOfKeys[2]++
                        } else if numOfKeys[2] < numOfKeys[timeList[1][notePointer]] {
                            numOfKeys[timeList[1][notePointer]]--
                            numOfKeys[2]++
                            timeList[1][notePointer] = 2
                        }/* else if timeList[2][notePointer] == 0 {
                        timeList[2][notePointer] = 1
                        numOfKeys[0]++
                        }*/
                    }
                }
                sampleIncrease_high = 0
            }
            
            if spec_ehigh[i + 1] > spec_ehigh[i]
            { sampleIncrease_ehigh += spec_ehigh[i + 1] - spec_ehigh[i] }
            else {
                if sampleIncrease_ehigh > VU_ehigh[i] * 0.8 && sampleIncrease_ehigh < 2 * VU_ehigh[i] {
                    interval = sample[i + 1] - startTime_ehigh
                    if interval >= 0.1 {
                        if sample[i] - Double(timeList[0][notePointer]) / 44100 > 0.1 {
                            startTime_ehigh = sample[i]
                            notePointer++
                            timeList[0].append(Int(sample[i] * 44100))
                            timeList[1].append(3)
                            numOfKeys[0]++
                        } else if numOfKeys[3] < numOfKeys[timeList[1][notePointer]] {
                            numOfKeys[timeList[1][notePointer]]--
                            numOfKeys[3]++
                            timeList[1][notePointer] = 3
                        }/* else if timeList[2][notePointer] == 0 {
                        timeList[2][notePointer] = 1
                        numOfKeys[0]++
                        }*/
                    }
                }
                sampleIncrease_ehigh = 0
            }
        }
        
        
        var writeString: String = ""
        for var i: Int = 0; i < notePointer; i++ {
            writeString += (String(timeList[0][i]) + "\t" + String(timeList[1][i]) + "\n")
        }
        
        WriteFile.Write(writeString)
        
        //CafFile.DeleteFile()
        CafFile.OpenFile("export.m4a")
        CafFile.DeleteFile()
        
    }
}

