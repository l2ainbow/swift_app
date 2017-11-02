//
//  MockRunner.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/02.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class MockRunner
{
    /// 停止する
    func stop(){
        print("Stop Running")
    }
    
    
    /// 直進する
    /// - Parameter distance: 直進距離 [m]
    func straightRun(distance: Double){
        print("Run Straight for distance: \(distance)")
    }
    
    /// カーブ走行する
    /// - Parameter distance: 走行距離 [m]
    /// - Parameter angle: 目標角度 [rad]
    func curveRun(distance: Double, angle: Double){
        print("Run curvy for distance and angle: \(distance), \(angle)")
    }
    
    /// 旋回する
    /// - Parameter angle: 旋回角度 [rad]
    func spin(angle: Double){
        print("Spin for angle: \(angle)")
    }
}

