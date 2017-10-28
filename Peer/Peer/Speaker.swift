//
//  Speaker.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/15.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol Speaker
{
    
    // 音声を出力する
    // message: 出力音声メッセージ
    func speak(voice: String)
}

