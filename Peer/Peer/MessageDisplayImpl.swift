//
//  MessageDisplayImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import UIKit

public class MessageDisplayImpl : MessageDisplay
{
    // メッセージを表示するためのテキストラベル
    private var messageText : UILabel
    
    init(label: UILabel){
      self.messageText = label
    }
    
    // メッセージを表示する
    // message: 表示メッセージ文字列
    public func display(message: String){
      self.messageText.text = message
    }
} 
