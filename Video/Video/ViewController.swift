//
//  ViewController.swift
//  Video
//
//  Created by 外村真吾 on 2017/07/05.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // イメージビューを生成
        imageView = UIImageView()
        
        // スクリーンの設定
        Image.setScreen(imageView: imageView)
        
        // セッションを生成
        let cameraSession = Session()
        let output = cameraSession.setUpSession()
        
        // ピクセルフォーマットを 32bit BGR + A とする
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable : Int(kCVPixelFormatType_32BGRA)]
        
        // デリゲートを設定
        output.setSampleBufferDelegate(self, queue:DispatchQueue.main)
        
        // 遅れてきたフレームは無視する
        output.alwaysDiscardsLateVideoFrames = true
        
        // video出力に接続
        output.connection(withMediaType: AVMediaTypeVideo)

        // セッションスタート
        cameraSession.startSession()
        
        // 時間の設定
        // 未完成　引数は何でも
        cameraSession.setTime(time: 0)
        
    
    
    
    }
    
       
    
    // 毎フレーム実行される処理
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!)
    {
        
        let image = Image.imageFromSampleBuffer(sampleBuffer)
        DispatchQueue.main.async {
            self.imageView.image = image
            
            // UIImageViewをビューに追加
            self.view.addSubview(self.imageView)
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    

    
}
