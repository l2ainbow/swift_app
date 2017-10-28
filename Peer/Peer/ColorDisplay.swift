//
//  ColorDisplay.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol ColorDisplay
{
    // 色を表示する
    // R: 表示色のR(0-255)
    // G: 表示色のG(0-255)
    // B: 表示色のB(0-255)
    func display(R: UInt8, G: UInt8, B: UInt8)
    
    // 色を表示する
    // color: 表示色
    func display(color: Color)
}
