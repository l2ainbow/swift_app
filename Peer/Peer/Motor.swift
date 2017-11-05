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
    
    private var peripheral : CBPeripheral?
    private var characteristic : CBCharacteristic?
    
    init(peripheral: CBPeripheral?, characteristic: CBCharacteristic?){
        self.peripheral = peripheral
        self.characteristic = characteristic
    }
    
    /// モータを回転する
    /// - Parameter pwm: モータのPWM
    func rotate(pwm: Int){
        let data = String(pwm).data(using: .utf8)!
        if (self.peripheral != nil){
            self.peripheral?.writeValue(data as Data, for: self.characteristic!, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    /// モータを停止する
    func stop(){
        self.rotate(pwm: 0)
    }
}
