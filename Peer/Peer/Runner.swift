//
//  Runner.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/02.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol Runner
{
    /// 停止する
    func stop()
    
    /// 直進する
    /// - Parameter distance: 直進距離 [m]
    func straightRun(distance: Double)
    
    /// カーブ走行する
    /// - Parameter distance: 走行距離 [m]
    /// - Parameter angle: 目標角度 [rad]
    func curveRun(distance: Double, angle: Double)
    
    /// 旋回する
    /// - Parameter angle: 旋回角度 [rad]
    func spin(angle: Double)
}

