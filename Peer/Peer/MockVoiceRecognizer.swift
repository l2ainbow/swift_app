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
    
    func recognize() {

    }
    
    func getText() -> String {
        Thread.sleep(forTimeInterval: 1)
        //return "五日後の天気はどうですか"
        //return "ついてきて"
        cnt += 1
        if (cnt % 2 == 0){
            return "青"
        }
        return "音楽再生"
    }
}
