//
//  MessageDisplay.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol MessageDisplay
{
    // メッセージを表示する
    // message: 表示メッセージ文字列
    func display(message: String)
}
