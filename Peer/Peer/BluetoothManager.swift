//
//  BluetoothManager.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/11.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation
import CoreBluetooth

public class BluetoothManager : NSObject{

    /// シングルトンインスタンス
    static let shared = BluetoothManager()
    
    /// BLE UUID
    let SERVICE_UUID = CBUUID(string: "6C680000-F374-4D39-9FD8-A7DBB54CD6EB")
    /// 使用するキャラクタリスティックのUUID配列
    let CHAR_UUIDS: [String : CharacteristicType] = [
        "6C680001-F374-4D39-9FD8-A7DBB54CD6EB" : .LeftMotor,
        "6C680002-F374-4D39-9FD8-A7DBB54CD6EB" : .RightMotor,
        "6C680003-F374-4D39-9FD8-A7DBB54CD6EB" : .LED
    ]
    
    /// セントラルの管理
    var centralManager: CBCentralManager!
    /// ペリフェラル
    var peripheral: CBPeripheral?
    /// キャラクタリスティク
    var characteristics: [CharacteristicType : CBCharacteristic?] = [
        CharacteristicType.RightMotor : nil,
        CharacteristicType.LeftMotor : nil,
        CharacteristicType.LED : nil
    ]
    
    private override init(){
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /// キャラクタリスティクの値を上書きする
    /// - Parameters:
    ///   - value: キャラクタリスティクの値
    ///   - type: キャラクタリスティクの種類
    public func writeValue(value: Data, type: CharacteristicType){
        if (self.peripheral != nil && characteristics[type] != nil){
            self.peripheral?.writeValue(value, for: characteristics[type]!!, type: CBCharacteristicWriteType.withResponse)
        }
    }
}

extension BluetoothManager : CBCentralManagerDelegate {
    /// Bluetooth状態遷移時の処理
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: [SERVICE_UUID]) // Peripheralのスキャン開始
            print("state=powerOn, start to scan\(SERVICE_UUID)")
        default:
            break
        }
    }
    
    /// Peripheral発見時の処理
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        // print("ペリフェラル発見:%@",peripheral.name!)
        centralManager.stopScan()
        
        central.connect(peripheral, options: nil)
    }
    
    /// Peripheralとの接続切断時の処理
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (error != nil){
            print("Peripheral切断時エラー:%@", error!)
            return
        }
        print("ペリフェラル切断:%@",peripheral.name!)
        centralManager.scanForPeripherals(withServices: [SERVICE_UUID])
    }
    
    /// Periphralとの接続時の処理
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // print("ペリフェラルとの接続成功:%@",peripheral.name!)
        self.peripheral = peripheral
        centralManager.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_UUID])
    }
}

// MARK:- CBPeripheralからのコールバック
extension BluetoothManager: CBPeripheralDelegate {
    /// サービス発見時の処理
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if (error != nil){
            print("サービス発見時エラー:%@", error!)
            return
        }
        print("サービス発見:%@",peripheral.services!)
        peripheral.discoverCharacteristics([], for: (peripheral.services?.first)!)
    }
    
    /// キャラクタリスティック発見時の処理
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if (error != nil){
            print("キャラクタリスティック発見時エラー:%@", error!)
            return
        }
        
        for characteristic in service.characteristics!
        {
            print("キャラクタリスティク発見:%@",characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
            if let type = CHAR_UUIDS[characteristic.uuid.uuidString] {
                self.characteristics[type] = characteristic
            }
        }
    }
    
    /// キャラクタリスティクのデータ更新時の処理
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil){
            print("データ更新エラー:%@", error!)
            return
        }
    }
}

/// キャラクタリスティクの種類
/// - RightMotor: 右モータ
/// - LeftMotor: 左モータ
/// - LED: LED
public enum CharacteristicType {
    case RightMotor, LeftMotor, LED
}
