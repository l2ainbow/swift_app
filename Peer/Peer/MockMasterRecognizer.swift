//
//  MockMasterRecognizer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/02.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

public class MockMasterRecognizer: MasterRecognizer
{
    /// マスターの位置を認識する
    /// - Returns: マスターの位置
    public func recognize() -> Position {
        let distance = Double(arc4random_uniform(100)) / 100.0 * 5.0
        
        let angle = Double(arc4random_uniform(360)) / 180.0 * Double.pi - Double.pi
        return Position(distance: distance, angle: angle)
    }
}
