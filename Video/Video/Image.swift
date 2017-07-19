//
//  Image.swift
//  Video
//
//  Created by 外村真吾 on 2017/07/15.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Image {
    
    static func setScreen(imageView : UIImageView) {
        
        //スクリーンの幅
        let screenWidth = UIScreen.main.bounds.size.width;
        
        //スクリーンの高さ
        let screenHeight = UIScreen.main.bounds.size.height;
        
        // プレビュー用のビューを生成
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
        
    }
    
    
    static func imageFromSampleBuffer(_ sampleBuffer :CMSampleBuffer) -> UIImage {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        // イメージバッファのロック
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        
        // 画像情報を取得
        let base = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)!
        let bytesPerRow = UInt(CVPixelBufferGetBytesPerRow(imageBuffer))
        let width = UInt(CVPixelBufferGetWidth(imageBuffer))
        let height = UInt(CVPixelBufferGetHeight(imageBuffer))
        
        // ビットマップコンテキスト作成
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerCompornent = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) as UInt32)
        let newContext = CGContext(data: base, width: Int(width), height: Int(height), bitsPerComponent: Int(bitsPerCompornent), bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        // 画像作成
        let imageRef = newContext.makeImage()!
        let image = UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImageOrientation.right)
        
        // イメージバッファのアンロック
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return image
    }

    
    
}
