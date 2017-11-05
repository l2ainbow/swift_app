//
//  FollowMasterUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/02.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class FollowMasterUseCase
{
    private var masterRecognizer: MasterRecognizer
    private var follower: Follower
    private var colorDisplay: ColorDisplay
    private var messageDisplay: MessageDisplay
    
    init (colorDisplay: ColorDisplay, masterRecognizer: MasterRecognizer, follower: Follower, messageDisplay: MessageDisplay){
        self.masterRecognizer = masterRecognizer
        self.follower = follower
        self.colorDisplay = colorDisplay
        self.messageDisplay = messageDisplay
    }
    
    /// ユースケースを開始する
    public func start()
    {
        colorDisplay.display(color: Color.Blue)
        messageDisplay.display(message: "追走中...")
        var position = Position(distance: 0, angle: 0)
        repeat{
            position = masterRecognizer.recognize()
        }
        while(follower.follow(position: position))
    }
}
