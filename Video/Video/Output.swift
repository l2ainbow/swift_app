//
//  Output.swift
//  Video
//
//  Created by 外村真吾 on 2017/07/15.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class Output{
    
    
    
    static func setOutput(output : AVCaptureVideoDataOutput) {
    
        // ピクセルフォーマットを 32bit BGR + A とする
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable : Int(kCVPixelFormatType_32BGRA)]
        
        // デリゲートを設定
        output.setSampleBufferDelegate(self, queue:DispatchQueue.main)
        
        // 遅れてきたフレームは無視する
        output.alwaysDiscardsLateVideoFrames = true
        
        // video出力に接続
        output.connection(withMediaType: AVMediaTypeVideo)

        
    }
    
    
    
        
}
