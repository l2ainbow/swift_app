//
//  ViewController.swift
//  Peer
//
//  Created by 外村真吾 on 2017/07/21.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreBluetooth

class ViewController: UIViewController {
    /** 構造体 **/
    // キャラクタリスティックの構造体
    struct Characteristic{
        // UUID
        let uuid: CBUUID
        // キャラクタリスティック名
        let name: String
        // 送受信データのバイト数
        let byte: Int
    }
    
    /** 定数 **/
    // P2P通信のサービス名
    let SERVICE_TYPE = "LCOC-Chat"
    
    // BLE UUID
    let SERVICE_UUID = CBUUID(string: "6C680000-F374-4D39-9FD8-A7DBB54CD6EB")
    // 使用するキャラクタリスティックの配列
    let CHAR_UUIDs:[String:Characteristic] = [
        "leftMotor":Characteristic(uuid: CBUUID(string: "6C680001-F374-4D39-9FD8-A7DBB54CD6EB"), name: "leftMotor", byte: 4),
        "rightMotor":Characteristic(uuid: CBUUID(string: "6C680002-F374-4D39-9FD8-A7DBB54CD6EB"), name: "rightMotor", byte: 4),
        "LED":Characteristic(uuid: CBUUID(string: "6C680003-F374-4D39-9FD8-A7DBB54CD6EB"), name: "LED", byte: 3)
    ]
    
    /** 変数 **/
    // MultiConnectivity関連
    // MultiConnectivityのViewController
    var browser : MCBrowserViewController!
    // アドバタイズのアシスタント
    var assistant : MCAdvertiserAssistant!
    // セッション
    var session : MCSession!
    // 接続先のID
    var peerID: MCPeerID!
    
    // Bluetooth関連
    // セントラルの管理
    var centralManager: CBCentralManager!
    // ペリフェラル
    var peripheral: CBPeripheral!
    // 左モータを表すキャラクタリスティック
    var leftMotorCharacteristic : CBCharacteristic?
    // 右モータを表すキャラクタリスティック
    var rightMotorCharacteristic : CBCharacteristic?
    // LEDを表すキャラクタリスティック
    var ledCharacteristic : CBCharacteristic?
    
    // 音声スピーカー
    var speaker = SpeakerImpl()
    
    // カラー表示
    var colorDisplay : ColorDisplay!
    
    // メッセージ表示
    var messageDisplay: MessageDisplay!
    
    // 音声指令ユースケース
    var voiceOrderUC: VoiceOrderUseCase!

    // 状態を表すテキスト
    @IBOutlet weak var conditionText: UILabel!
    
    /** メソッド **/
    // Viewの読込完了時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // P2P通信の初期化
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // P2P通信接続用のViewControllerの初期化
        self.browser = MCBrowserViewController(serviceType:SERVICE_TYPE,
                                               session:self.session)
        self.browser.delegate = self;
        
        // P2P通信のアドバタイザの初期化
        self.assistant = MCAdvertiserAssistant(serviceType:SERVICE_TYPE,
                                               discoveryInfo:nil, session:self.session)
        self.assistant.start()
        
        // Bluetooth初期化
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // ユースケースの初期化
        self.voiceOrderUC = Initializer.initialize(delegate: self)
    }
    
    // ユースケース開始
    func startUC(){
        self.voiceOrderUC.start()
    }
    
    // 文字列のRGBを1byte整数配列に変換
    func formatRGB(str: String) -> [UInt8]{
        var rgb = ""
        var subStr = str
        var rgbData : [UInt8] = []
        
        for i in 0..<str.characters.count {
            
            subStr = str.substring(from: str.index(str.startIndex, offsetBy: i))
            
            if (String(subStr[subStr.startIndex]) == ","){
                
                rgbData.append(UInt8(rgb)!)
                rgb = ""
                
            } else {
                
                rgb = rgb + String(subStr[subStr.startIndex])
                print(rgb)
            }
            
        }
        rgbData.append(UInt8(rgb)!)
        return rgbData
    }
    
    // 左モータの回転
    func rotateLeftMotor(pwm: Int){
        let data = String(pwm).data(using: .utf8)!
        if (self.peripheral != nil){
            self.peripheral.writeValue(data as Data, for: self.leftMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    // 右モータの回転
    func rotateRightMotor(pwm: Int){
        let data = String(pwm).data(using: .utf8)!
        if (self.peripheral != nil){
            self.peripheral.writeValue(data as Data, for: self.rightMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }
    }

}

// MARK:- CBCentralManagerからのコールバック
extension ViewController: CBCentralManagerDelegate {
    // Bluetooth状態遷移時の処理
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: [SERVICE_UUID]) // Peripheralのスキャン開始
            print("state=powerOn, start to scan\(SERVICE_UUID)")
        default:
            break
        }
    }
    
    // Peripheral発見時の処理
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        // print("ペリフェラル発見:%@",peripheral.name!)
        centralManager.stopScan()
        
        central.connect(peripheral, options: nil)
    }
    
    // Peripheralとの接続切断時の処理
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (error != nil){
            print("Peripheral切断時エラー:%@", error!)
            return
        }
        print("ペリフェラル切断:%@",peripheral.name!)
        conditionText.text = "Bluetooth接続が切断されました。"
        self.colorDisplay.display(R: 255, G: 0, B: 0)
        centralManager.scanForPeripherals(withServices: [SERVICE_UUID])
    }
    
    // Periphralとの接続時の処理
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // print("ペリフェラルとの接続成功:%@",peripheral.name!)
        self.peripheral = peripheral
        centralManager.stopScan()
        self.colorDisplay.display(R: 0, G: 255, B: 0)
        conditionText.text = "Bluetooth接続しました。"
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_UUID])
    }
}

// MARK:- CBPeripheralからのコールバック
extension ViewController: CBPeripheralDelegate {
    // サービス発見時の処理
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if (error != nil){
            print("サービス発見時エラー:%@", error!)
            return
        }
        print("サービス発見:%@",peripheral.services!)
        peripheral.discoverCharacteristics([], for: (peripheral.services?.first)!)
    }
    
    // キャラクタリスティック発見時の処理
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if (error != nil){
            print("キャラクタリスティック発見時エラー:%@", error!)
            return
        }
        
        for characteristic in service.characteristics!
        {
            print("キャラクタリスティク発見:%@",characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
            
            if (characteristic.value == nil) {
                let a = 0
                characteristic.setValue(a, forKey: "")
            }
            
            switch characteristic.uuid{
            case (CHAR_UUIDs["leftMotor"]?.uuid)!:
                leftMotorCharacteristic = characteristic
                break
            case (CHAR_UUIDs["rightMotor"]?.uuid)!:
                rightMotorCharacteristic = characteristic
                break
            case (CHAR_UUIDs["LED"]?.uuid)!:
                ledCharacteristic = characteristic
                break
            default:
                break
            }
        }
        self.startUC()
    }
    
    // キャラクタリスティクのデータ更新時の処理
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil){
            print("データ更新エラー:%@", error!)
            return
        }
    }
}

// MARK:- MCBrowserViewControllerからのコールバック
extension ViewController: MCBrowserViewControllerDelegate {
    // P2P通信接続完了時の処理
    func browserViewControllerDidFinish(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is dismissed (ie the Done
        // button was tapped)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // P2P通信接続キャンセル時の処理
    func browserViewControllerWasCancelled(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is cancelled
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- MCSessionからのコールバック
extension ViewController: MCSessionDelegate {
    
    // P2P通信にて相手からNSDataが送られてきたとき(sendメソッドによりおくられる)
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        
        DispatchQueue.main.async() {
            let str = String(data: data, encoding: .utf8)!
            print(str)
            let prefix = str[str.startIndex]
            let val = str.substring(from: str.index(str.startIndex, offsetBy: 1))
            
            switch prefix {
            case "l":
                self.rotateLeftMotor(pwm: Int(val)!)
                break
            case "r":
                self.rotateRightMotor(pwm: Int(val)!)
                break
            case "d":
                self.rotateLeftMotor(pwm: Int(val)!)
                self.rotateRightMotor(pwm: Int(val)!)
                break
            case "s":
                self.speaker.speak(message: val)
                self.conditionText.text = val
                break
            case "c":
                var bytes = self.formatRGB(str: val)
                self.colorDisplay.display(R: bytes[0], G: bytes[1], B: bytes[2])
                break
            default:
                break
            }
        }
        
    }
    
    // P2P通信にてピアからファイル受信開始した時の処理
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress)  {
        
        // 何もしない
    }
    
    // P2P通信にてピアからファイル受信完了した時の処理
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL, withError error: Error?)  {
        // 何もしない
    }
    
    // P2P通信にてピアからストリーム受信した時の処理
    func session(_ session: MCSession, didReceive stream: InputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID)  {
        // 何もしない
    }
    
    // P2P通信にてピアの状態が変化した時の処理
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState)  {
        // 何もしない
    }
}
