//
//  MasterRecognizer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/02.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol MasterRecognizer
{
    /// マスターの位置を認識する
    /// - Returns: マスターの位置
    func recognize() -> Position
}
