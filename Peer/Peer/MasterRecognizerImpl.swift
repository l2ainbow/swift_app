//
//  MasterRecognizerImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/05.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class MasterRecognizerImpl : MasterRecognizer
{
    /// マスターの位置を認識する
    /// - Returns: マスターの位置
    public func recognize() -> Position {
        // - TODO: 【外村】ここにカメラ撮影を実装する
        return Position(distance: 0, angle: 0)
    }
}
