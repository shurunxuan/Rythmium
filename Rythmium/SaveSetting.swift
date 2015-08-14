//
//  SaveSetting.swift
//  Rythmium
//
//  Created by 舒润萱 on 15/8/14.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import Foundation

func SaveSetting() {
    
    var string = String()
    for (content , value) in settings {
        string += content + "\t" + value + "\n"
    }
    settingFile.Write(string)
    
    
    
}
