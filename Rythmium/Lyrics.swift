//
//  Lyrics.swift
//  Rythmium
//
//  Created by 舒润萱 on 15/10/7.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import Foundation

extension Character
{
    func toInt() -> Int
    {
        var intFromCharacter:Int = 0
        for i in String(self).utf8
        {
            intFromCharacter = Int(i)
        }
        return intFromCharacter
    }
}

extension String
{
    subscript(integerIndex: Int) -> Character
        {
            let index = characters.index(startIndex, offsetBy: integerIndex)
            return self[index]
    }
    
    subscript (r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[startIndex...endIndex])
        }
    }
}

func isLrc(_ lrc: String?) -> Bool {
    if lrc == nil { return false }
    let strList = lrc!.components(separatedBy: CharacterSet.newlines)
    for str in strList where !str.isEmpty {
        if !str.hasPrefix("[") {
            return false
        }
    }
    return true
}

func buildLrcList(_ lrc: String?) -> Bool {
    
    LrcList = [:]
    LrcTimeList = []
    
    if !isLrc(lrc) { return false }
    
    let strList = lrc!.components(separatedBy: CharacterSet.newlines)
    
    var offset: Double = 0.0
    
    for line in strList where line.hasPrefix("[offset") || line.hasPrefix("[Offset") || line.hasPrefix("[OFFSET") {
        var str = ""
        for char in line.characters where char.toInt() >= 48 && char.toInt() <= 57 {
            str.append(char)
        }
        offset = Double(str)! / 1000.0
        break
    }
    
    for line in strList where !line.isEmpty {
        if line[1].toInt() >= 48 && line[1].toInt() <= 57 {
            let list = line.components(separatedBy: "]")
            let lyric = list.last
            for timeStamp in list where timeStamp.hasPrefix("[") {
                let minute = Double(timeStamp[1...2])
                let second = Double(timeStamp[4...8])
                if minute == nil || second == nil { return false }
                let time = minute! * 60 + second! + offset
                
                LrcList[time] = lyric
                LrcTimeList.append(time)
            }
        }
    }
    LrcTimeList.sort()
    return true
}
