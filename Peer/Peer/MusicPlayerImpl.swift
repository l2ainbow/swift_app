//
//  MusicPlayerImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/06.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import MediaPlayer
import AVFoundation

public class MusicPlayerImpl: MusicPlayer
{
    var audioPlayer : AVAudioPlayer?

    public func play(music: Music){
        let property = MPMediaPropertyPredicate(value: music.id, forProperty: MPMediaPropertyPersistentID)
        let query = MPMediaQuery()
        query.addFilterPredicate(property)
        let items = query.items
        if items.empty{
            return
        }
        audioPlayer = AVAudioPlayer(contentOfURL: items[0].assetURL)
        audioPlayer.play()
    }
    
    public func pause(){
        if audioPlayer {
            audioPlayer.pause()
        }
    }
    
    public func terminate(){
        if audioPlayer {
            audioPlayer.stop()
        }
    }
    
    public func waitForEnd(){
        // -TODO: ここを実装
    }
}
