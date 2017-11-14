//
//  VoiceOrderUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//
import Foundation
public class VoiceOrderUseCase
{
    private var voiceRecognizer: VoiceRecognizer
    private var voiceDetector: VoiceDetector
    private var colorDisplay: ColorDisplay
    private var messageDisplay: MessageDisplay
    
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
        messageDisplay.display(message: "音声検出中...")
        print("\n")
        print("=============start============")
        print("\n")
        while(!voiceDetector.detect()){}
        var order: VoiceOrder = VoiceOrder(order: "", voiceString: "")
        print("===detect")
        var result: String = ""
        result = voiceRecognizer.recognize()
        if (result.contains("バディ") || result.contains("バリ") || result.contains("針")){
            messageDisplay.display(message: "音声認識中...")
            colorDisplay.display(color: Color.Yellow)
            order.voiceString = voiceRecognizer.recognize()
        }
        
        if (KeywordSearcher.search(string: order.voiceString, keyword: "天気")){
            order.order = "WeatherInform"
        }
        else if (KeywordSearcher.search(string: order.voiceString, keywords: ["ついてきて", "おいかけて", "ついてこい", "来て"])){
            order.order = "FollowMaster"
        }
        else if (KeywordSearcher.search(string: order.voiceString, keywords: ["音楽", "聞きたい", "聴きたい", "ミュージック", "曲"])){
            order.order = "JukeBox"
        }
        else if (KeywordSearcher.search(string: order.voiceString, keyword: "ごきげんよう")){
            order.order = "Talking"
        }
        else {
            order.order = ""
        }
        return order
    }
    
    
}
