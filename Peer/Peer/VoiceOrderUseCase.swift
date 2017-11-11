//
//  VoiceOrderUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import AudioToolbox
public class VoiceOrderUseCase
{
    private var voiceRecognizer: VoiceRecognizer
    private var voiceDetector: VoiceDetector
    private var colorDisplay: ColorDisplay
    private var messageDisplay: MessageDisplay
    private var timer: Timer!
    
    init (colorDisplay: ColorDisplay, voiceDetector: VoiceDetector, voiceRecognizer: VoiceRecognizer, messageDisplay: MessageDisplay){
        self.colorDisplay = colorDisplay
        self.voiceDetector = voiceDetector
        self.voiceRecognizer = voiceRecognizer
        self.messageDisplay = messageDisplay
    }
    
    /// ユースケースを開始する
    /// - Returns: 音声指令
    public func start() -> VoiceOrder
    {
        // TODO: 【外村】必要があればstart()の内容を修正する
        colorDisplay.display(color: Color.Green)
        print("\n")
        print("=============start============")
        print("\n")
        //self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.textCheck(_:)), userInfo: self, repeats: true)
        //self.timer?.fire()
        //voiceDetector.detect() // start
        //while(!voiceDetector.detectVolume()){} // volume get
        //print("====\(voiceRecognizer.recognize())")
        voiceDetector.detect() // start
        while(!voiceDetector.detectVolume()){} // volume get
        voiceRecognizer.recognize()
        colorDisplay.display(color: Color.Yellow)
        messageDisplay.display(message: "音声認識中...")
        
        var order: VoiceOrder = VoiceOrder(order: "", voiceString: "")
        order.voiceString = voiceRecognizer.getText()
        
        if (KeywordSearcher.search(string: order.voiceString, keyword: "天気")){
            order.order = "WeatherInform"
        }
        else if (KeywordSearcher.search(string: order.voiceString, keywords: ["ついてきて", "おいかけて", "ついてこい", "来て"])){
            order.order = "FollowMaster"
        }
        else if (KeywordSearcher.search(string: order.voiceString, keywords: ["音楽", "聞きたい", "聴きたい", "ミュージック", "曲"])){
            order.order = "JukeBox"
        }
        return order
    }
    
    @objc func textCheck(_ timer: Timer){
        if(voiceRecognizer.getText() != "===return") {
         
            print(voiceRecognizer.getText())
            voiceDetector.detect()
            while(!voiceDetector.detectVolume()){}
            voiceRecognizer.recognize()
        }

    }
    
}
