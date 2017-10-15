//
//  Speaker.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/15.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import AVFoundation

class Speaker {
    
    // 音声の速度(0.1-1.0)
    let VOICE_RATE = Float(0.5)
    // 音声の高さ(0.5-2.0)
    let VOICE_PITCH = Float(1.3)
    
    // 音声出力のシンセサイザー
    var synthesizer = AVSpeechSynthesizer()
    
    // 文字列の読み上げ
    func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.rate = VOICE_RATE
        utterance.pitchMultiplier = VOICE_PITCH
        self.synthesizer.speak(utterance)
    }
}
