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
    
    init (colorDisplay: ColorDisplay, masterRecognizer: MasterRecognizer, follower: Follower){
        self.masterRecognizer = masterRecognizer
        self.follower = follower
        self.colorDisplay = colorDisplay
    }
    
    /// ユースケースを開始する
    public func start()
    {
        colorDisplay.display(color: Color.Blue)
        var position = Position(distance: 0, angle: 0)
        repeat{
            position = masterRecognizer.recognize()
        }
        while(follower.follow(position: position))
    }
}
