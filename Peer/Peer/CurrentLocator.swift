//
//  CurrentLocator.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol CurrentLocator
{
    /// 現在位置を検出する
    /// - Returns: 現在位置
    func locate() -> Location
}
