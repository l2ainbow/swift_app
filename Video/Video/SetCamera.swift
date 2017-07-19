//
//  SetCamera.swift
//  Video
//
//  Created by 外村真吾 on 2017/07/15.
//  Copyright © 2017年 Shingo. All rights reserved.
//
import AVFoundation

class SetCamera {
    
    let cameraSession = Session()
    
    func getFrontCamera() {
    
        let camera : AVCaptureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        
        cameraSession.setDevice(device: camera)
        
    }
    
    func setUpInput() {
        
        let camera : AVCaptureDevice = cameraSession.getDevice()
        
        let session = cameraSession.getSession()
        
        let cameraInput : AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: camera)
        
        cameraSession.setInput(input: cameraInput)
        
        session.addInput(cameraInput)
        
    }
    
    
    
}
