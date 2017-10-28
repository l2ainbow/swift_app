//
//  SpeakerImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/15.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import AVFoundation

public class SpeakerImpl: Speaker
{
    // 音声の速度(0.1-1.0)
    let VOICE_RATE = Float(0.5)
    // 音声の高さ(0.5-2.0)
    let VOICE_PITCH = Float(1.3)
    
    // 音声出力のシンセサイザー
    let synthesizer = AVSpeechSynthesizer()    

    public func speak(message: String)
    {
        let utterance = AVSpeechUtterance(string: message)
        utterance.rate = VOICE_RATE
        utterance.pitchMultiplier = VOICE_PITCH
        self.synthesizer.speak(utterance)
    }
}
