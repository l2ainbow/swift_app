//
//  MockMasterRecognizer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/02.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class MockMasterRecognizer
{
    /// マスターの位置を認識する
    /// - Returns: マスターの位置
    func recognize() -> Position {
        let distance = Double(arc4random_uniform(100)) / 100.0 * 5.0
        let angle = Double(arc4random_uniform(360)) / 180.0 * PI - PI
        return Postion(distance, angle)
    }
}
