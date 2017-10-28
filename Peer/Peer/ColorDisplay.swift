//
//  ColorDisplay.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol ColorDisplay
{

    func display(R: UInt8, G: UInt8, B: UInt8)
    
    func display(color: Color)
}
