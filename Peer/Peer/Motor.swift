//
//  Motor.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/05.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation
import CoreBluetooth

public class Motor {
    /// PWMの最大値
    public static let MAX_PWM = 100
    
    /// キャラクタリスティクの種類
    private var type: CharacteristicType
    
    init(type: MotorType){
        self.type = CharacteristicType.RightMotor
        if (type == MotorType.Left){
            self.type = CharacteristicType.LeftMotor
        }
    }
    
    /// モータを回転する
    /// - Parameter pwm: モータのPWM
    func rotate(pwm: Int){
        let data = String(pwm).data(using: .utf8)!
        BluetoothManager.shared.writeValue(value: data, type: type)
    }
    
    /// モータを停止する
    func stop(){
        self.rotate(pwm: 0)
    }
}

/// モータの種類
/// - Right: 右モータ
/// - Left: 左モータ
public enum MotorType {
    case Right, Left
}
