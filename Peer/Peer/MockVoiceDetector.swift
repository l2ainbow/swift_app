//
//  MockVoiceDetector.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

class MockVoiceDetector : VoiceDetector{

    func detect() {

    }
    func detectVolume() -> Bool{
        Thread.sleep(forTimeInterval: 1)
        return true
    }
}
