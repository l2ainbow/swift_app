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
    /// 制御周期 [s]
    private let CONTROL_CYCLE = 0.5
    
    private var cnt = 0;
    
    /// マスターの位置を認識する
    /// - Returns: マスターの位置
    public func recognize() -> Position {
        Thread.sleep(forTimeInterval: CONTROL_CYCLE)
        var pos = Position(distance: 0.3, angle: 0.2)
        if (cnt < 5){
            pos = randomPosition()
        }
        let deg = pos.angle * 180 / Double.pi
        print("distance=\(pos.distance), angle=\(pos.angle)(\(deg)deg))")
        cnt += 1
        return pos
    }
    
    /// ランダムに位置を取得する
    /// - Returns: マスターの位置
    private func randomPosition() -> Position{
        let distance = Double(arc4random_uniform(100)) / 100.0 * 5.0
        let angle = Double(arc4random_uniform(360)) / 180.0 * Double.pi - Double.pi
        return Position(distance: distance, angle: angle)
    }
}
