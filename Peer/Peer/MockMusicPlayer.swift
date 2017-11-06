//
//  MockMusicPlayer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/06.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

public class MockMusicPlayer: MusicPlayer
{
    public func play(music: Music){
        print("Play music: \(music.artist), \(music.title)")
    }
    
    public func pause(){
        print("Pause music player")
    }
    
    public func terminate(){
        print("Terminate music player")
    }
    
    public func waitForEnd(){
        print("Wait for the end of the music")
        Thread.sleep(forTimeInterval: 5)
    }
}
