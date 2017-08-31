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
import AVFoundation

class ViewController: UIViewController, MCBrowserViewControllerDelegate,
MCSessionDelegate, UITextFieldDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    // キャラクタリスティックの構造体
    struct Characteristic{
        let uuid: CBUUID
        let name: String
        let byte: Int
    }
    
    let serviceType = "LCOC-Chat"
    
    // 音声パラメータ
    let VOICE_RATE = Float(0.5) // 0.1-1.0
    let VOICE_PITCH = Float(1.3) // 0.5-2.0
    
    // BLE UUID
    let SERVICE_UUID = CBUUID(string: "6C680000-F374-4D39-9FD8-A7DBB54CD6EB")
    let CHAR_UUIDs:[String:Characteristic] = [
        "leftMotor":Characteristic(uuid: CBUUID(string: "6C680001-F374-4D39-9FD8-A7DBB54CD6EB"), name: "leftMotor", byte: 4),
        "rightMotor":Characteristic(uuid: CBUUID(string: "6C680002-F374-4D39-9FD8-A7DBB54CD6EB"), name: "rightMotor", byte: 4)
    ]
    
    // MultiConnectivity関連
    var browser : MCBrowserViewController!   //
    var assistant : MCAdvertiserAssistant!   //
    var session : MCSession!                 //セッション
    var peerID: MCPeerID!                    //接続先の名前
    
    // Bluetooth関連
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral! // BLEペリフェラル
    var leftMotorCharacteristic : CBCharacteristic?
    var rightMotorCharacteristic : CBCharacteristic?
    
    // ユーザデータ
    var leftValue : Int!                     //左の数値
    var rightValue : Int!                    //右の数値
    var objc : Receiver!                     //objective-C呼び出しのオブジェクト
    var synthesizer = AVSpeechSynthesizer() // 音声生成
    
    @IBOutlet weak var leftLabel: UILabel! //左側の数値のラベル
    @IBOutlet weak var rightLabel: UILabel! //右側の数値のラベル
    @IBOutlet weak var leftLowerLabel: UILabel! // 左下の数値のラベル
    @IBOutlet weak var rightLowerLabel: UILabel! // 右下の数値のラベル
    @IBOutlet weak var peerMessageLabel: UILabel! // ピアからの受信文字列を表示するラベル
    @IBOutlet weak var speakMessageBox: UITextField! // 発話用テキストボックス
    
    // Viewの読込完了時
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // P2P通信の初期化
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
                                               session:self.session)
        self.browser.delegate = self;
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
                                               discoveryInfo:nil, session:self.session)
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()
        
        // 数値初期化
        self.leftValue = 0
        self.rightValue = 0
        
        self.speakMessageBox.delegate = self
        
        // Bluetooth初期化
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Bluetooth状態遷移時
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: [SERVICE_UUID]) // Peripheralのスキャン開始
            print("state=powerOn, start to scan\(SERVICE_UUID)")
        default:
            break
        }
    }
    
    // Peripheral発見時
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        print("ペリフェラル発見:%@",peripheral.name!)
        centralManager.stopScan()
        
        central.connect(peripheral, options: nil)
    }
    
    // Peripheralとの接続切断時
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (error != nil){
            print("Peripheral切断時エラー:%@", error!)
            return
        }
        print("ペリフェラル切断:%@",peripheral.name!)
        
        centralManager.scanForPeripherals(withServices: [SERVICE_UUID])
    }
 
    // Periphralとの接続時
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("ペリフェラルとの接続成功:%@",peripheral.name!)
        self.peripheral = peripheral
        centralManager.stopScan()
        
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_UUID])
    }
    
    // サービス発見時
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if (error != nil){
            print("サービス発見時エラー:%@", error!)
            return
        }
        print("サービス発見:%@",peripheral.services!)
        peripheral.discoverCharacteristics([], for: (peripheral.services?.first)!)
    }
    
    // キャラクタリスティック発見時
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if (error != nil){
            print("キャラクタリスティック発見時エラー:%@", error!)
            return
        }
        
        for characteristic in service.characteristics!
        {
            print("キャラクタリスティク発見:%@",characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
            
            switch characteristic.uuid{
            case (CHAR_UUIDs["leftMotor"]?.uuid)!:
                leftLowerLabel.text = String(data: characteristic.value!, encoding: .utf8)
                leftMotorCharacteristic = characteristic
                break
            case (CHAR_UUIDs["rightMotor"]?.uuid)!:
                rightLowerLabel.text = String(data: characteristic.value!, encoding: .utf8)
                rightMotorCharacteristic = characteristic
                break
            default:
                break
            }
        }
    }
    
    // キャラクタリスティクのデータ更新時
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil){
            print("データ更新エラー:%@", error!)
            return
        }
        switch characteristic.uuid{
        case (CHAR_UUIDs["leftMotor"]?.uuid)!:
            leftLowerLabel.text = String(data: characteristic.value!, encoding: .utf8)
            break
        case (CHAR_UUIDs["rightMotor"]?.uuid)!:
            rightLowerLabel.text = String(data: characteristic.value!, encoding: .utf8)
            break
        default:
            break
        }
    }
    
    // 文章の読み上げ
    func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.rate = VOICE_RATE
        utterance.pitchMultiplier = VOICE_PITCH
        self.synthesizer.speak(utterance)
    }
    
    // P2P通信による送信
    func sendToPeer(message: String){
        let data = message.data(using: .utf8)!
        do {
            try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
        } catch {
            print(error)
        }
    }
    
    // 左スライドを動かした時呼び出される
    @IBAction func slide1(_ sender: UISlider) {
        leftValue = Int(100 * sender.value)
        
        // 数値のP2P通信
        let str : String = "l" + String(leftValue)
        sendToPeer(message: str)
        
        // ラベルの更新
        leftLabel.text = String(leftValue)
        // 数値の読み上げ
        speak(word: "左" + leftLabel.text!)
        
        // BLE通信にて送信
        let data = String(leftValue).data(using: .utf8)!
        if (peripheral != nil){
            peripheral.writeValue(data, for: leftMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    // 右スライドを動かした時呼び出される
    @IBAction func slide2(_ sender: UISlider) {
        rightValue = Int(100 * sender.value)
        
        // 数値のP2P通信
        let str : String = "r" + String(rightValue)
        sendToPeer(message: str)
        
        // ラベルの更新
        rightLabel.text = String(rightValue)
        // 数値の読み上げ
        speak(word: "右" + rightLabel.text!)
        
        // BLE通信にて送信
        let data = String(rightValue).data(using: .utf8)!
        if (peripheral != nil){
            peripheral.writeValue(data, for: rightMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    //逆回転のボタンを押した時呼び出される
    @IBAction func reverse(_ sender: UIButton) {
        //speak(word: "そこは、おさないで？")
        speak(word: speakMessageBox.text!)
        
        // 右モータの数値を送る
        rightValue = -1 * rightValue
        rightLabel.text = String(rightValue)
        let rStr:String = "r" + String(rightValue)
        sendToPeer(message: rStr)
        
        // 左モータの数値を送る
        leftValue = -1 * leftValue
        leftLabel.text = String(leftValue)
        let lStr:String = "l" + String(leftValue)
        sendToPeer(message: lStr)
        
        // BLE通信にて送信
        let rData = String(rightValue).data(using: .utf8)!
        if (peripheral != nil){
            peripheral.writeValue(rData, for: rightMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }
        let lData = String(leftValue).data(using: .utf8)!
        if (peripheral != nil){
            peripheral.writeValue(lData, for: leftMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    @IBAction func getText(sender: UITextField)
    {
        //speakMessageBox.text = sender.text
    }
    
    // ラベルの更新
    func updateLabelleft(num : Int) {
        leftLabel.text = String(num)
    }
    
    func updateLabelright(num : Int) {
        rightLabel.text = String(num)
    }
    
    // ブラウザボタンを押した時呼び出される
    @IBAction func showBrowser(_ sender: UIButton) {
        self.present(self.browser, animated: true, completion: nil)
    }
    
    func browserViewControllerDidFinish(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is dismissed (ie the Done
        // button was tapped)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is cancelled
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // 相手からNSDataが送られてきたとき(sendメソッドによりおくられる)
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        
        DispatchQueue.main.async() {
            // objective-Cメソッド呼び出し用オブジェクト生成
            self.objc = Receiver()
            let str = String(data: data, encoding: .utf8)!
            
            print(str)
            self.peerMessageLabel.text = str
            let prefix = str[str.startIndex]
            let val = str.substring(from: str.index(str.startIndex, offsetBy: 1))
            
            // ラベルの更新(左右の判定)左の数値は1000足された値
            switch prefix {
            case "l":
                self.leftValue = Int(val);
                self.updateLabelleft(num: Int(val)!)
                self.objc.getLeftData(Int(val)!)
                let data = String(self.leftValue).data(using: .utf8)!
                if (self.peripheral != nil){
                    self.peripheral.writeValue(data, for: self.leftMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                }
                break
            case "r":
                self.rightValue = Int(val);
                self.updateLabelright(num: Int(val)!)
                self.objc.getRightData(Int(val)!)
                let data = String(self.rightValue).data(using: .utf8)!
                if (self.peripheral != nil){
                    self.peripheral.writeValue(data, for: self.rightMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                }
                break
            case "d":
                self.rightValue = Int(val);
                self.updateLabelright(num: Int(val)!)
                self.objc.getRightData(Int(val)!)
                self.leftValue = Int(val);
                self.updateLabelleft(num: Int(val)!)
                self.objc.getLeftData(Int(val)!)
                let rdata = String(self.rightValue).data(using: .utf8)!
                let ldata = String(self.leftValue).data(using: .utf8)!
                if (self.peripheral != nil){
                    self.peripheral.writeValue(rdata, for: self.rightMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                }
                if (self.peripheral != nil){
                    self.peripheral.writeValue(ldata, for: self.leftMotorCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                }
                break
            case "s":
                self.speak(word: val)
                break
            default:
                break
            }
        }
        
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress)  {
        
        // Called when a peer starts sending a file to us
    }
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL, withError error: Error?)  {
        // Called when a file has finished transferring from another peer
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID)  {
        // Called when a peer establishes a stream with us
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState)  {
        // Called when a connected peer changes state (for example, goes offline)
        
    }
    
    
    
}
