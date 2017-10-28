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
    private var messageText : UILabel
    
    init(label: UILabel){
      self.messageText = label
    }
    
    public func display(message: String){
      self.messageText.text = message
    }
} 
