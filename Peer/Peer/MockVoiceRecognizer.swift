//
//  MockVoiceRecognizer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

class MockVoiceRecognizer : VoiceRecognizer{
    private var cnt = 0
    
    func recognize() -> String {
        Thread.sleep(forTimeInterval: 1)
        cnt += 1
        if (cnt == 1){
            return "バディ"
        }
        //return "五日後の天気はどうですか"
        //return "ついてきて"
 
        if (cnt == 2){
            return "音楽再生"
        }
        if (cnt == 3){
            return "冬"
        }
        return ""
    }
    
    
    
}
