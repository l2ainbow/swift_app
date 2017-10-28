//
//  VoiceOrderUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class VoiceOrderUseCase
{
    private var voiceRecognizer: VoiceRecognizer
    private var voiceDetector: VoiceDetector
    private var colorDisplay: ColorDisplay
    private var weatherInformUC: WeatherInformUseCase
    
    init (colorDisplay: ColorDisplay, voiceDetector: VoiceDetector, voiceRecognizer: VoiceRecognizer, weatherInformUC: WeatherInformUseCase){
        self.colorDisplay = colorDisplay
        self.voiceDetector = voiceDetector
        self.voiceRecognizer = voiceRecognizer
        self.weatherInformUC = weatherInformUC
    }
    
    // ユースケースを開始する
    // -> 音声指令
    public func start() -> VoiceOrder
    {
        // TODO: 【外村】必要があればstart()の内容を修正する
        colorDisplay.display(color: Color.Green)
        while(!voiceDetector.detect()){
        }
        
        colorDisplay.display(color: Color.Yellow)
        
        var order: VoiceOrder = VoiceOrder(order: "", voiceString: "")
        order.voiceString = voiceRecognizer.recognize()
        
        if (KeywordSearcher.search(string: order.voiceString, keyword: "天気")){
            order.order = "WeatherInform"
        }
        return order
    }
}
