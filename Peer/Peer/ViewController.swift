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
import Foundation

class ViewController: UIViewController, UIGestureRecognizerDelegate{
    //-- 定数 --//
    /// P2P通信のサービス名
    let SERVICE_TYPE = "LCOC-Chat"
    
    //-- 変数 --//
    // <MultiConnectivity関連>
    /// MultiConnectivityのViewController
    var browser : MCBrowserViewController!
    /// アドバタイズのアシスタント
    var assistant : MCAdvertiserAssistant!
    /// セッション
    var session : MCSession!
    /// 接続先のID
    var peerID: MCPeerID!
    
    // <UI関連>
    /// 状態を表すテキスト
    @IBOutlet weak var conditionText: UILabel!
    /// テキストの高さを可変にする
    conditionText.numberOfLines = 0
    conditionText.sizeToFit()
    conditionText.lineBreakMode = LineBreakByWordWrapping
    
    // <その他>
    /// 音声スピーカー
    var speaker : Speaker!
    /// カラー表示
    var colorDisplay : ColorDisplay!
    /// メッセージ表示
    var messageDisplay: MessageDisplay!
    /// ユースケース制御
    var useCaseController: UseCaseController!
    /// 右モータ
    var rightMotor: Motor!
    /// 左モータ
    var leftMotor: Motor!

    //-- メソッド --//
    /// Viewの読込完了時の処理
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
        
        // タップ処理の初期化
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        // 長押し処理の初期化
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPressed(_:)))
        self.view.addGestureRecognizer(longPressGesture)
        longPressGesture.delegate = self
        
        // ユースケースの初期化
        Initializer.initialize(delegate: self)
        
        // 接続中の表示
        self.colorDisplay.display(R: 255, G: 0, B: 0)
        self.messageDisplay.display(message: "接続中...")
    }
    
    /// Viewの表示完了時の処理
    override func viewDidAppear(_ animated: Bool) {
        let queue = DispatchQueue(label: "useCaseController.listenVoiceOrder")
        queue.async{
            while(true){
                self.useCaseController.listenVoiceOrder()
            }
        }
    }
    
    /// Viewがタップされた時の処理
    @objc func tapped(_ sender: UITapGestureRecognizer){
        if sender.state == .ended {
            self.useCaseController.displayDidTapped()
        }
    }
    
    /// Viewが長押しされた時の処理
    @objc func longPressed(_ sender: UILongPressGestureRecognizer){
        if sender.state == .ended {
            self.useCaseController.displayDidLongPressed()
        }
    }
    
    /// 文字列のRGBを1byte整数配列に変換する
    /// - Parameter str: RGB文字列
    /// - Returns: RGB(0-255)の配列
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
}

// MARK:- MCBrowserViewControllerからのコールバック
extension ViewController: MCBrowserViewControllerDelegate {
    /// P2P通信接続完了時の処理
    func browserViewControllerDidFinish(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is dismissed (ie the Done
        // button was tapped)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /// P2P通信接続キャンセル時の処理
    func browserViewControllerWasCancelled(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is cancelled
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- MCSessionからのコールバック
extension ViewController: MCSessionDelegate {
    
    /// P2P通信にて相手からNSDataが送られてきたとき(sendメソッドによりおくられる)
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        
        DispatchQueue.main.async() {
            let str = String(data: data, encoding: .utf8)!
            print(str)
            let prefix = str[str.startIndex]
            let val = str.substring(from: str.index(str.startIndex, offsetBy: 1))
            
            switch prefix {
            case "l":
                self.leftMotor.rotate(pwm: Int(val)!)
                break
            case "r":
                self.rightMotor.rotate(pwm: Int(val)!)
                break
            case "d":
                self.leftMotor.rotate(pwm: Int(val)!)
                self.rightMotor.rotate(pwm: Int(val)!)
                break
            case "s":
                self.speaker.speak(voice: val)
                self.messageDisplay.display(message: val)
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
    
    /// P2P通信にてピアからファイル受信開始した時の処理
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress)  {
        
        // 何もしない
    }
    
    /// P2P通信にてピアからファイル受信完了した時の処理
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL, withError error: Error?)  {
        // 何もしない
    }
    
    /// P2P通信にてピアからストリーム受信した時の処理
    func session(_ session: MCSession, didReceive stream: InputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID)  {
        // 何もしない
    }
    
    /// P2P通信にてピアの状態が変化した時の処理
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState)  {
        // 何もしない
    }
}
