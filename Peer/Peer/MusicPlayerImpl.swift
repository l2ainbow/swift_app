//
//  MusicPlayerImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/06.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import MediaPlayer
import AVFoundation

public class MusicPlayerImpl: NSObject, MusicPlayer
{
    var audioPlayer : AVAudioPlayer?
    
    let semaphore = DispatchSemaphore(value: 0)

    public func play(music: Music){
        let property = MPMediaPropertyPredicate(value: music.id, forProperty: MPMediaItemPropertyPersistentID)
        let query = MPMediaQuery()
        query.addFilterPredicate(property)
        if let items = query.items {
            if (items.isEmpty){
                return
            }
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: (items[0].assetURL)!)
                audioPlayer?.play()
                audioPlayer?.delegate = self
            } catch  {
                print("audioPlayer cannot load")
                return
            }
        }
    }
    
    public func pause(){
        if (audioPlayer != nil) {
            if (audioPlayer?.isPlaying)!{
                audioPlayer?.pause()
            }
            else {
                audioPlayer?.play()
            }
        }
    }
    
    public func terminate(){
        if (audioPlayer != nil) {
            audioPlayer?.stop()
        }
    }
    
    public func waitForEnd(){
        semaphore.wait()
    }
}

extension MusicPlayerImpl: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        semaphore.signal()
    }
}
