//
//  VoiceDetector.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol VoiceDetector
{
    // 音声を検出する
    // -> 検出可否(true: 検出した, false: 未検出)
    func detect()
    func detectVolume() -> Bool
}
