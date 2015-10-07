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
            let index = startIndex.advancedBy(integerIndex)
            return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String
        {
            let start = startIndex.advancedBy(integerRange.startIndex)
            let end = startIndex.advancedBy(integerRange.endIndex)
            let range = start..<end
            return self[range]
    }
}

func isLrc(lrc: String) -> Bool {
    let strList = lrc.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    for str in strList {
        print(str)
        if str != "" {
            if !str.hasPrefix("[") {
                return false
            }
        }
    }
    return true
}

func buildLrcList(lrc: String) -> Bool {
    
    LrcList = [:]
    LrcTimeList = []
    
    if !isLrc(lrc) { return false }
    
    let strList = lrc.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    
    for line in strList where !line.isEmpty {
        if line[1].toInt() >= 48 && line[1].toInt() <= 57 {
            let list = line.componentsSeparatedByString("]")
            let lyric = list.last
            for timeStamp in list where timeStamp.hasPrefix("[") {
                let minute = Double(timeStamp[1...2])
                let second = Double(timeStamp[4...8])
                if minute == nil || second == nil { return false }
                let time = minute! * 60 + second!
                
                LrcList[time] = lyric
                LrcTimeList.append(time)
            }
        }
    }
    LrcTimeList.sortInPlace()
    return true
}