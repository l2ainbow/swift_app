//
//  MusicPlayer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/06.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol MusicPlayer
{
    /// 音楽を再生する
    /// - Parameters:
    ///   - music: 再生する音楽
    func play(music: Music)
    
    /// 音楽を一時停止する
    func pause()
    
    /// 音楽再生を終了する
    func terminate()
    
    /// 音楽が終了するまで待つ
    func waitForEnd()
}
