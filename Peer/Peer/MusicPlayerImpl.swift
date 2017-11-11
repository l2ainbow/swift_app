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
    
    /// 音楽を再生する
    /// - Parameters:
    ///   - music: 再生する音楽
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
    
    /// 音楽を一時停止する
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
    
    /// 音楽再生を終了する
    public func terminate(){
        // - TOOD: 一時停止の処理になっているので、音楽再生を終了するように変更
        if (audioPlayer != nil) {
            audioPlayer?.stop()
            audioPlayer = nil
        }
        semaphore.signal()
    }
    
    /// 音楽が終了するまで待つ
    public func waitForEnd(){
        semaphore.wait()
    }
}

extension MusicPlayerImpl: AVAudioPlayerDelegate {
    /// 音楽が終了した時の処理
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        terminate()
    }
}
