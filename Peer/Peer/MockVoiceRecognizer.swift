//
//  MockVoiceRecognizer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

class MockVoiceRecognizer : VoiceRecognizer{
    func recognize() -> String {
        Thread.sleep(forTimeInterval: 1)
        return "弥な明後日の天気はどうですか"
        //return "ついてきて"
    }
}
