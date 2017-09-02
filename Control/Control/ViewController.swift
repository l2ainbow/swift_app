//
//  ViewController.swift
//  Peer
//
//  Created by 外村真吾 on 2017/07/21.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ViewController: UIViewController, MCBrowserViewControllerDelegate,
MCSessionDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let serviceType = "LCOC-Chat"
    
    
    var browser : MCBrowserViewController!   //
    var assistant : MCAdvertiserAssistant!   //
    var session : MCSession!                 //セッション
    var peerID: MCPeerID!                    //接続先の名前
    var buttons : [UIButton]!            // buttonを配列として管理
    var index : Int!                      // buttonのindex
    var leftData : String!                // 左側のデータ"左 + PWM値"
    var rightData : String!                // 右側のデータ"右 + PWM値"
    var leftLabelText = ""              // ラベル用の変数
    var rightLabelText = ""            // ラベル用の変数
    var pwmLeftLabelText = ""              // ラベル用の変数
    var pwmRightLabelText = ""            // ラベル用の変数
    var pwm : Int!
    var pwmStr = ""
    
    var pwmData : Int!                   // PWM値
    var sameButtonCondition = true       // 同時ボタン状態
    var speakContents = ["こんにちは", "晴れどす", "えらい、はずかしいどすなぁ", "通知どす",
                         "そんなこと、できひん", "よろしぅ", "おおきに","ご飯の時間だよ","おなか空いたよう","雨降りそうだよ","遅刻しちゃうよ"]  // 話す内容を格納する変数
    var speakContent = "こんにちは"
    
    // 音声用の選択リスト
    @IBOutlet weak var speakPicker: UIPickerView!
    
    // leftbutton: indexを上から0として0 ~ 9のindexをそれぞれ振る
    @IBOutlet weak var leftButton5: UIButton!
    @IBOutlet weak var leftButton4: UIButton!
    @IBOutlet weak var leftButton3: UIButton!
    @IBOutlet weak var leftButton2: UIButton!
    @IBOutlet weak var leftButton1: UIButton!
    
    // rightbutton
    @IBOutlet weak var rightButton5: UIButton!
    @IBOutlet weak var rightButton4: UIButton!
    @IBOutlet weak var rightButton3: UIButton!
    @IBOutlet weak var rightButton2: UIButton!
    @IBOutlet weak var rightButton1: UIButton!
    
    // PWM値のLabel
    @IBOutlet weak var pwmLabel: UILabel!
    
    // Condition
    @IBOutlet weak var conditionLabel: UILabel!

    
    // 同時ボタン
    @IBOutlet weak var sameButton: UIButton!
    
    
    
    
    // セッション
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonsSet() // buttonの割り当て
        self.speakPicker.delegate = self
        self.speakPicker.dataSource = self
        
        
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
    }
    
    
    // それぞれのswtchを押した際に呼ばれる
    @IBAction func leftButton5Touch(_ sender: UIButton) {
        
        index = 4
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    @IBAction func leftButton4Touch(_ sender: UIButton) {
        
        index = 3
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    @IBAction func leftButton3Touch(_ sender: UIButton) {
        
        index = 2
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    @IBAction func leftButton2Touch(_ sender: UIButton) {
        
        index = 1
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    @IBAction func leftButton1Touch(_ sender: UIButton) {
        
        index = 0
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    @IBAction func rightButton5Touch(_ sender: UIButton) {
        
        index = 9
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    @IBAction func rightButton4Touch(_ sender: UIButton) {
        
        index = 8
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    @IBAction func rightButton3Touch(_ sender: UIButton) {
        
        index = 7
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    @IBAction func rightButton2Touch(_ sender: UIButton) {
        
        index = 6
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    @IBAction func rightButton1Touch(_ sender: UIButton) {
        
        index = 5
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    // 停止ボタンを押した際に呼ばれる
    @IBAction func stopButtonTouch(_ sender: UIButton) {
        
        index = 10
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    // 回転ボタンを押した際に呼ばれる
    @IBAction func rotationButtonTouch(_ sender: UIButton) {
        
        index = 11
        self.buttonConditionUpdate(buttonIndex: index)
        
    }
    
    // 話すボタンを押した際に呼ばれる
    @IBAction func speakButtonTouch(_ sender: UIButton) {
        
        index = 12
        self.buttonConditionUpdate(buttonIndex: index)
    
        
    }
    
    
    // 端末ボタンを押した際に呼ばれる
    @IBAction func showBrowser(_ sender: UIButton) {
        
        self.present(self.browser, animated: true, completion: nil)
        
    }
    
    
    // buttonの割り当てをする
    func buttonsSet() {
        
        buttons = []
        buttons.append(leftButton1)
        buttons.append(leftButton2)
        buttons.append(leftButton3)
        buttons.append(leftButton4)
        buttons.append(leftButton5)
        buttons.append(rightButton1)
        buttons.append(rightButton2)
        buttons.append(rightButton3)
        buttons.append(rightButton4)
        buttons.append(rightButton5)
        
    }
    
    
    @IBAction func sameButtonTouch(_ sender: UIButton) {
        
        if (sameButtonCondition) {
            
            sameButtonCondition = false
            sameButton.setTitle("片側", for: UIControlState.normal)
            
        } else {
            
            sameButtonCondition = true
            sameButton.setTitle("同時", for: UIControlState.normal)
            
        }
        
        
    }
    
    // 全てのbuttonの状態を更新
    func buttonConditionUpdate(buttonIndex: Int) {
        
        // 左側button切り替え
        if (buttonIndex < 5) {
            
            self.leftButtonColorRiset()
            self.buttons[buttonIndex].setTitleColor(UIColor.red, for: .normal)
            
            if (sameButtonCondition) {
             
                self.rightButtonColorRiset()
                self.buttons[buttonIndex + 5].setTitleColor(UIColor.red, for: .normal)
                
                conditionLabelUpdate(buttonIndex: buttonIndex + 5)
                
            }
            
         sendData(index: buttonIndex)
            
        }
        
        // 右側button切り替え
        if (buttonIndex >= 5 && buttonIndex < 10) {
            
            self.rightButtonColorRiset()
            self.buttons[buttonIndex].setTitleColor(UIColor.red, for: .normal)
            
            if (sameButtonCondition) {
       
                self.leftButtonColorRiset()
                self.buttons[buttonIndex - 5].setTitleColor(UIColor.red, for: .normal)
                
                conditionLabelUpdate(buttonIndex: buttonIndex - 5)
                
            }
            
            sendData(index: buttonIndex)
        
   
        } else if (buttonIndex == 10) {
            //停止
            self.leftButtonColorRiset()
            self.rightButtonColorRiset()
            self.buttons[2].setTitleColor(UIColor.red, for: .normal)
            self.buttons[7].setTitleColor(UIColor.red, for: .normal)
            sendData(index: 2)
            sendData(index: 7)
            
        } else if (buttonIndex == 11) {
            //回転
            self.leftButtonColorRiset()
            self.rightButtonColorRiset()
            
            sameButtonCondition = false
            sameButton.setTitle("片側", for: UIControlState.normal)
            
            //self.buttons[3].setTitleColor(UIColor.red, for: .normal)
            //self.buttons[6].setTitleColor(UIColor.red, for: .normal)

            self.buttons[4].setTitleColor(UIColor.red, for: .normal)
            self.buttons[5].setTitleColor(UIColor.red, for: .normal)

            //変更前からこの値だけど大丈夫？
            sendData(index: 4)
            sendData(index: 5)
            
        } else if (buttonIndex == 12) {
            
            sendData(index: buttonIndex)
            
        }
        
        conditionLabelUpdate(buttonIndex: buttonIndex)

    }
    
    // Labelに現在の状態を表示
    func conditionLabelUpdate(buttonIndex: Int) {
        
        if (buttonIndex == 10) {
            
            conditionLabel.text = "    停止"
            
        } else if (buttonIndex == 11) {
            
            conditionLabel.text = "    回転"
            
        } else if (buttonIndex == 12) {
            
            conditionLabel.text = "    話す"
            
        } else {
            
            if (buttonIndex < 5) {
                
                leftLabelText = "    左: \(buttonIndex - 2)"
                
            }
            
            
            if (buttonIndex >= 5) {
                
                rightLabelText = "    右: \(buttonIndex - 7)"
            }
            
            conditionLabel.text = leftLabelText + rightLabelText
            
        }
    }
    
    // 左側のボタンを全て青にする
    func leftButtonColorRiset() {
        
        for i in 0..<5 {
            
            self.buttons[i].setTitleColor(UIColor.blue, for: .normal)
            
        }
        
    }
    
    // 右側のボタンを全て青にする
    func rightButtonColorRiset() {
        
        for i in 5..<10 {
            
            self.buttons[i].setTitleColor(UIColor.blue, for: .normal)
            
        }
        
    }
    
    // PWM値を計算して表示する
    func calcPWM(buttonIndex: Int) -> String {
        
        if (buttonIndex < 5) {
            
            pwm = (buttonIndex - 2) * 50
            if (pwm > 0) {
                pwm = pwm + 30
            } else if (pwm  < 0){
                pwm = pwm - 30
            }
            if (pwm > 100) {
                pwm = 100
            }
            if (pwm < -100) {
                pwm = -100
            }
            pwmLeftLabelText = "PWM左:"  + String(pwm)
            pwmStr = "l"
            
        } else if (buttonIndex < 10 && buttonIndex >= 5) {
            
            pwm = (buttonIndex - 7) * 50
            if (pwm > 0) {
                pwm = pwm + 30
            } else if (pwm < 0) {
                pwm = pwm - 30
            }
            if (pwm > 100) {
                pwm = 100
            }
            if (pwm < -100) {
                pwm = -100
            }
            pwmRightLabelText = "PWM右:" + String(pwm)
            pwmStr = "r"
            
        }
        
        pwmLabel.text = pwmLeftLabelText + pwmRightLabelText
        
        
        if (sameButtonCondition) {
            
            pwmStr = "d"
            pwmLabel.text = "PWM:" + String(pwm)
            
        }
        
        
        pwmStr += String(pwm)
        return pwmStr
        
    }
    
    // データを送信する
    func sendData(index : Int) {
        
        var dataStr : String!
        
        if (index < 10) {
            
            dataStr = calcPWM(buttonIndex: index)
            
        
        } else if (index == 12){
            
            dataStr = "s" + speakContent
            
        }
        
        let data = dataStr.data(using: .utf8)!
        
        do {
            try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
        } catch {
            print(error)
        }
        
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
            
            // 検証用
            let dataStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print(dataStr!)
           // print(dataStr)
            
            
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
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
     pickerに表示する行数を返すデータソースメソッド.
     (実装必須)
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speakContents.count
    }
    
    /*
     pickerに表示する値を返すデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return speakContents[row]
    }
    
    /*
     pickerが選択された際に呼ばれるデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        speakContent = speakContents[row]
        
    }
}







