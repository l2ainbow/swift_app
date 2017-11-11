//
//  RunnerImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/05.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

public class RunnerImpl: Runner
{
    /// バディの長さ [m]
    let LENGTH = 0.077
    // バディの幅 [m]
    let WIDTH = 0.097
    // バディの高さ [m]
    let HEIGHT = 0.05
    // タイヤの半径 [m]
    let RADIUS = 0.025
    // カーブ係数
    let K_CURVE = 1.0

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
        let ob = distance / sin(angle) / 2; //OBの長さ
        let br = sqrt(LENGTH * LENGTH + WIDTH * WIDTH) / 2; //中心から右前のタイヤの長さ
        let cos_obr = WIDTH / sqrt(LENGTH * LENGTH + WIDTH * WIDTH); //cos_OBR
        let Or = sqrt(ob * ob + br * br - 2 * ob * br * cos_obr);
        let Dr = 2 * Or * Double.pi * (angle / Double.pi);
        let Wr = Dr / (2 * Double.pi * RADIUS);
        
        let ol = sqrt(ob * ob + br * br + 2 * ob * br * cos_obr);
        let Dl = 2 * ol * Double.pi * (angle / Double.pi);
        let Wl = Dl / (2 * Double.pi * RADIUS);
        
        var rMotorSpeed = 0.0
        var lMotorSpeed = 0.0
        if(abs(Wr) < abs(Wl)){
            let lower = Wr / Wl * K_CURVE;
            rMotorSpeed = Double(Motor.MAX_PWM) * lower
            lMotorSpeed = Double(Motor.MAX_PWM)
        }
        else{
            let lower = Wl / Wr * K_CURVE;
            rMotorSpeed = Double(Motor.MAX_PWM)
            lMotorSpeed = Double(Motor.MAX_PWM) * lower
        }
        self.rightMotor.rotate(pwm: Int(rMotorSpeed))
        self.leftMotor.rotate(pwm: Int(lMotorSpeed))
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
