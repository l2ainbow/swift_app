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

class ViewController: UIViewController, MCBrowserViewControllerDelegate,
MCSessionDelegate, UITextFieldDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    struct Characteristic{
        let uuid: CBUUID
        let name: String
        let byte: Int
    }
    
    let serviceType = "LCOC-Chat"
    
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
    
    // ユーザデータ
    var leftValue : Int!                     //左の数値
    var rightValue : Int!                    //右の数値
    var sign : Int!                          //符号
    var objc : Receiver!                     //objective-C呼び出しのオブジェクト
    
    @IBOutlet weak var leftLabel: UILabel! //左側の数値のラベル
    @IBOutlet weak var rightLabel: UILabel! //右側の数値のラベル
    
    // セッション
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
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
         */
        
        // 数値初期化
        self.sign = 1
        
        // Bluetooth初期化
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Bluetooth状態遷移時
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: [SERVICE_UUID]) // Peripheralのスキャン開始
            //centralManager.scanForPeripherals(withServices: nil) // Peripheralのスキャン開始
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
    /*
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (error != nil){
            print("Peripheral発見時エラー:%@", error!)
            return
        }
        self.peripheral = peripheral
        print("ペリフェラル発見:%@",peripheral.name!)
        centralManager.stopScan()
        
        central.connect(peripheral, options: nil)
    }
    */
    
    // Periphralとの接続時
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("ペリフェラルとの接続成功:%@",peripheral.name!)
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
        peripheral.setNotifyValue(true, for: (service.characteristics?.first)!)
        
        for characteristic in service.characteristics!
        {
            print("キャラクタリスティク発見:%@",characteristic)
            switch characteristic.uuid{
            case (CHAR_UUIDs["leftMotor"]?.uuid)!:
                leftLabel.text = String(data: characteristic.value!, encoding: .utf8)
                break
            case (CHAR_UUIDs["rightMotor"]?.uuid)!:
                rightLabel.text = String(data: characteristic.value!, encoding: .utf8)
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
            leftLabel.text = String(data: characteristic.value!, encoding: .utf8)
            break
        case (CHAR_UUIDs["rightMotor"]?.uuid)!:
            rightLabel.text = String(data: characteristic.value!, encoding: .utf8)
            break
        default:
            break
        }
    }
    
    // 左スライドを動かした時呼び出される
    @IBAction func slide1(_ sender: UISlider) {
        leftValue = sign * (Int(256 * sender.value) + 1000)
        //let data = NSData(bytes: &leftValue, length: MemoryLayout<NSInteger>.size)
        /*
        do {
            try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
        } catch {
            print(error)
        }
         */
        
        leftLabel.text = String(leftValue - (sign *  1000))
        
    }
    
    // 右スライドを動かした時呼び出される
    @IBAction func slide2(_ sender: UISlider) {
        rightValue = sign * Int(256 * sender.value)
        //let data = NSData(bytes: &rightValue, length: MemoryLayout<NSInteger>.size)
        
        /*
        do {
            try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
        } catch {
            print(error)
        }
        */
        
        rightLabel.text = String(rightValue)
        
    }
    
    //逆回転のボタンを押した時呼び出される
    @IBAction func reverse(_ sender: UIButton) {
        sign = sign * (-1)
        var rvalue = -1 * rightValue
        rightLabel.text = String(rvalue)
        var data = NSData(bytes: &(rvalue), length: MemoryLayout<NSInteger>.size)
        
        /*
        // dataを送る
        do {
            try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
        } catch {
            print(error)
        }
        */
        var lvalue = -1 * leftValue
        leftLabel.text = String(lvalue - (sign * 1000))
        data = NSData(bytes: &lvalue, length: MemoryLayout<NSInteger>.size)
        
        /*
        // dataを送る
        do {
            try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
        } catch {
            print(error)
        }
        */
        
        
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
        
        sign = 1
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
            let data = NSData(data: data)
            var numData : NSInteger = 0
            data.getBytes(&numData, length: data.length)
            // ラベルの更新(左右の判定)左の数値は1000足された値
            if (1000 <= numData && 1256 >= numData) {
                self.updateLabelleft(num: (numData - 1000))
                self.objc.getLeftData(numData)
            } else if (numData <= -1000) {
                self.updateLabelleft(num: (numData + 1000))
                self.objc.getLeftData(numData)
            } else {
                self.updateLabelright(num: numData)
                self.objc.getRightData(numData)
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







