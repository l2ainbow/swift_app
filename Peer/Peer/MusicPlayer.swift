//
//  MusicPlayer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/06.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol MusicPlayer
{
    func play(music: Music)
    
    func pause()
    
    func terminate()
    
    func waitForEnd()
}
