//
//  ColorDisplay.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol ColorDisplay
{
    /// 色を表示する
    /// - Parameters:
    ///   - R: 表示色のR(0-255)
    ///   - G: 表示色のG(0-255)
    ///   - B: 表示色のB(0-255)
    func display(R: UInt8, G: UInt8, B: UInt8)
    
    /// 色を表示する
    /// - Parameter color: 表示色
    func display(color: Color)
    
    /// イルミネーションのように色を変化させながらゆっくり点滅を繰り返す
    /// - Parameter
    ///   - interval: 色を変える間隔 [s]
    ///   - colors: 表示色（複数指定可能；要素順で表示）
    ///   - isRepeat: 最後の色まで到達したら先頭の色に戻って繰り返すか（true: 繰り返す、false: 繰り返さない）
    func illuminate(interval: Double, colors: [Color], isRepeat: Bool)
}
