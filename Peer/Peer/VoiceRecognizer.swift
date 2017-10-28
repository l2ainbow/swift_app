//
//  VoiceRecognizer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol VoiceRecognizer
{
    // 音声を認識する
    // -> 認識した音声文字列
    func recognize() -> String
}
