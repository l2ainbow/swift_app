//
//  RunnerImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/05.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class RunnerImpl: Runner
{
    /// 右モータ
    var rightMotor: Motor
    /// 左モータ
    var leftMotor: Motor
    
    init(rightMotor: Motor, leftMotor: Motor){
        self.rightMotor = rightMotor
        self.leftMotor = leftMotor
    }
    
    /// 停止する
    public func stop(){
        self.rightMotor.stop()
        self.leftMotor.stop()
    }
    
    /// 直進する
    /// - Parameter distance: 直進距離 [m]
    public func straightRun(distance: Double){
        self.rightMotor.rotate(pwm: Motor.MAX_PWM)
        self.leftMotor.rotate(pwm: Motor.MAX_PWM)
    }
    
    /// カーブ走行する
    /// - Parameter distance: 走行距離 [m]
    /// - Parameter angle: 目標角度 [rad]
    public func curveRun(distance: Double, angle: Double){
        // - TODO: 前島くんのシミュレーションが完成したら実装
    }
    
    /// 旋回する
    /// - Parameter angle: 旋回角度 [rad]
    public func spin(angle: Double){
        if (angle > 0){
            // 右旋回の場合、左モータを正、右モータを負の方向に回転する
            self.rightMotor.rotate(pwm: -Motor.MAX_PWM)
            self.leftMotor.rotate(pwm: Motor.MAX_PWM)
        }
        else if (angle < 0){
            // 左旋回の場合、左モータを負、右モータを正の方向に回転する
            self.rightMotor.rotate(pwm: Motor.MAX_PWM)
            self.leftMotor.rotate(pwm: -Motor.MAX_PWM)
        }
        else{
            self.stop()
        }
    }
    
}
