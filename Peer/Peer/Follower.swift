//
//  Follower.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/15.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class Follower
{
    let MIN_DISTANCE_TO_FOLLOW = 0.5 // [m]
    let MIN_ANGLE_TO_SPIN = Double.pi / 2 // [rad]
    let MAX_ANGLE_TO_GO_STRAIGHT	 = Double.pi / 12 // [rad]

    var runner: Runner
    
    init(runner: Runner){
        self.runner = runner
    }
    
    /// 追走する
    /// - Parameter position: 追走する対象の位置
    /// - Returns: 追走中か(true: 追走中、false: 停止中)
    func follow(position: Position) -> Bool{
        if (position.distance < MIN_DISTANCE_TO_FOLLOW){
            runner.stop()
            return false
        }
        else if (position.angle <= -MIN_ANGLE_TO_SPIN || position.angle >= MIN_ANGLE_TO_SPIN ){
            runner.spin(angle: position.angle)
        }
        else if (position.angle >= -MAX_ANGLE_TO_GO_STRAIGHT || position.angle <= MAX_ANGLE_TO_GO_STRAIGHT){
            runner.straightRun(distance: position.distance)
        }
        else {
            runner.curveRun(distance: position.distance, angle: position.angle)
        }
        return true
    }
}

