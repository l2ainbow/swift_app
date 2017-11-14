//
//  FollowMasterUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/02.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class FollowMasterUseCase
{
    /// 人認識周期 [s]
    private let RECOGNIZE_CYCLE = 0.5
    
    private var masterRecognizer: MasterRecognizer
    private var follower: Follower
    private var colorDisplay: ColorDisplay
    private var messageDisplay: MessageDisplay
    
    private var willFinishFollowing = false
    
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
            if (willFinishFollowing){
                willFinishFollowing = false
                break
            }
            Thread.sleep(forTimeInterval: RECOGNIZE_CYCLE)
        
            position = masterRecognizer.recognize()
            print("recognize:" + String(position.distance) + "," + String(position.angle))
        }
        while(follower.follow(position: position))
    }
    
    /// ユースケースを強制終了する
    public func terminate(){
        willFinishFollowing = true
    }
    
}
