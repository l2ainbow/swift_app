//
//  Follower.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/15.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class Follower
{
    let PI = 3.1415926535898
    let MIN_DISTANCE_TO_FOLLOW = 0.5 // [m]
    let MIN_ANGLE_TO_SPIN = PI / 2 // [rad]
    let MAX_ANGLE_TO_GO_STRAIGHT = PI / 12 // [rad]

    var runner: Runner
    
    init(runner: Runner){
        self.runner = runner
    }
    
    /// 追走する
    /// - Parameter position: 追走する対象の位置
    /// - Returns: 追走中か(true: 追走中、false: 停止中)
    func follow(postion: Postion) -> boolean{
        if (postion.distance < MIN_DISTANCE_TO_FOLLOW){
            runner.stop()
            return false
        }
        else if (postion.angle <= - MIN_ANGLE_TO_SPIN || postion.angle >= MIN_ANGLE_TO_SPIN ){
            runner.spin(position.angle)
        }
        else if (postion.angle >= - MAX_ANGLE_TO_GO_STRAIGHT || position.angle <= MAX_ANGLE_TO_GO_STRAIGHT){
            runner.straightRun(position.distance)
        }
        else {
            runner.curveRun(position.distance, position.angle)
        }
        return true
    }
}

