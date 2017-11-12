//
//  VoiceDetectorImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//
import UIKit
import AudioToolbox


func AudioQueueInputCallback(
    _ inUserData: UnsafeMutableRawPointer?,
    inAQ: AudioQueueRef,
    inBuffer: AudioQueueBufferRef,
    inStartTime: UnsafePointer<AudioTimeStamp>,
    inNumberPacketDescriptions: UInt32,
    inPacketDescs: UnsafePointer<AudioStreamPacketDescription>?)
{
    
}

public class VoiceDetectorImpl: VoiceDetector
{
    
    private var queue: AudioQueueRef!
    private var timer: Timer!
    private var isDetect: Bool = false                                           /* 音量判定 */
    private var levelMeter = AudioQueueLevelMeterState()                    /* 音量のレベル */
    private var propertySize = UInt32(MemoryLayout<AudioQueueLevelMeterState>.size)
    private var timerCheck: Bool = false
    
    // 音声を検出する
    // -> 検出可否(true: 検出した, false: 未検出)
    public func detect() -> Bool {
        if (timer == nil){
            self.detectStart()
        }
        return self.isDetect
        
    }
    
    /**
     *
     * 音声検出を始める
     *
     */
    
    func detectStart(){
        
        var dataFormat = AudioStreamBasicDescription(
            mSampleRate: 44100.0,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: AudioFormatFlags(kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked),
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0)
        
        var audioQueue: AudioQueueRef? = nil
        var error = noErr
        error = AudioQueueNewInput(
            &dataFormat,
            AudioQueueInputCallback,
            UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            .none,
            .none,
            0,
            &audioQueue)
        if error == noErr {
            self.queue = audioQueue
        }
        AudioQueueStart(self.queue, nil)
        
        var enabledLevelMeter: UInt32 = 1
        AudioQueueSetProperty(self.queue, kAudioQueueProperty_EnableLevelMetering, &enabledLevelMeter, UInt32(MemoryLayout<UInt32>.size))
        DispatchQueue.main.async {
    
        /* timerの設定 */
            self.timer = Timer.scheduledTimer(timeInterval: 0.5,
                                          target: self,
                                          selector: #selector(self.detectVolume(_:)),
                                          userInfo: nil,
                                          repeats: true)
        
            self.timer.fire()
        }
        
    }
    /**
     * 音声検出をやめる。
     *
     */
    func detectStop()
    {
        self.timer.invalidate()
        self.timer = nil
        Thread.sleep(forTimeInterval: 3)
        self.isDetect = false
        AudioQueueFlush(self.queue)
        AudioQueueStop(self.queue, false)
        AudioQueueDispose(self.queue, true)
    }
    
    /**
     * start Update内で呼び出される
     * @param timer: 検出を繰り返す時間
     *
     */
    @objc public func detectVolume(_ timer: Timer)
    {
        
        AudioQueueGetProperty(
            self.queue,
            kAudioQueueProperty_CurrentLevelMeterDB,
            &levelMeter,
            &propertySize)
        
        /* 音声レベルの出力（デバッグ用） */
        print("========\(levelMeter.mAveragePower)")
        
        if (levelMeter.mPeakPower >= -10.0) {
            self.isDetect = true
            self.detectStop()
        } else {
            self.isDetect = false
        }
        self.timerCheck = true
    }
    
}
