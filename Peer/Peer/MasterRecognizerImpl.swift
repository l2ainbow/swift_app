//
//  MasterRecognizerImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/05.
//  Copyright © 2017年 Shingo. All rights reserved.
//
import UIKit
import AVFoundation

public class MasterRecognizerImpl : NSObject, MasterRecognizer, AVCaptureVideoDataOutputSampleBufferDelegate
{
    var imageView : UIImageView!
    var session : AVCaptureSession!
    var device : AVCaptureDevice!
    var input : AVCaptureDeviceInput!
    var output : AVCaptureVideoDataOutput!
    var position: Position = Position(distance: 0, angle: 0)
    
    override init() {
        super.init()
        // イメージビューを生成
        //imageView = UIImageView()
        
        // スクリーンの設定
        //self.setScreen(imageView: imageView)
        
        // セッションを生成
        
        let output = self.setUpSession()
        
        // ピクセルフォーマットを 32bit BGR + A とする
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable : Int(kCVPixelFormatType_32BGRA)]
        
        // デリゲートを設定
        output.setSampleBufferDelegate(self, queue:DispatchQueue(label: "cameraRunning"))
        
        // 遅れてきたフレームは無視する
        output.alwaysDiscardsLateVideoFrames = true
        
        // video出力に接続
        output.connection(withMediaType: AVMediaTypeVideo)
        
        // セッションスタート
        self.startSession()
        
        
    }
    /// マスターの位置を認識する
    /// - Returns: マスターの位置
    public func recognize() -> Position {
        // - TODO: 【外村】ここにカメラ撮影を実装する
        
        return self.position
        
    }
    
    
    func setScreen(imageView : UIImageView) {
        
        //スクリーンの幅
        let screenWidth = UIScreen.main.bounds.size.width;
        //スクリーンの高さ
        let screenHeight = UIScreen.main.bounds.size.height;
        // プレビュー用のビューを生成
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)

    }
    
    
    func imageFromSampleBuffer(_ sampleBuffer :CMSampleBuffer) -> UIImage {
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
    
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!)
    {
        
        let image = self.imageFromSampleBuffer(sampleBuffer)
        let objcpp = ObjCpp()
        let result: String = objcpp.calcPosition(image, distance: self.position.distance, radian: self.position.angle)
        print(result)
            //self.imageView.image = image
            
            // UIImageViewをビューに追加
            //ViewController().view.addSubview(self.imageView)
            self.position.angle += 1.0
            self.position.distance += 1.0
            
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}
