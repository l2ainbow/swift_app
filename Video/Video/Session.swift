//
//  Session.swift
//  Video
//
//  Created by 外村真吾 on 2017/07/15.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation
import AVFoundation


class Session {
    
    var session : AVCaptureSession!
    var device : AVCaptureDevice!
    var input : AVCaptureDeviceInput!
    var output : AVCaptureVideoDataOutput!
    
    // セッションの設定をする。
    func setUpSession() -> AVCaptureVideoDataOutput {
        
        // セッションの生成
        session = AVCaptureSession()
        
        // フロントカメラ取得
        device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        
        // インプットの取得
        input = try! AVCaptureDeviceInput(device: device)
        
        // インプットをセッションに追加
        session.addInput(input)
        
        // アウトプットを生成
        // 今回は動画から静止画をキャプチャするためVideoを設定
        output = AVCaptureVideoDataOutput()
        
        // アウトプットをセッションに追加
        session.addOutput(output)
        
        return output
        
    }
    
    
    
    // セッションをスタートする
    func startSession() {
        
        
        session.startRunning()
        
        
    }
    
    // 時間設定
    // 未完成　引数はなんでも同じ
    func setTime(time : Int) {
        
        device?.activeVideoMinFrameDuration = CMTimeMake(1, 30)
        
        
    }
}
