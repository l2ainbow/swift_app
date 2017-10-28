//
//  VoiceOrderUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class VoiceOrderUseCase
{
    init (colorDisplay: ColorDisplay, voiceDetector: VoiceDetector, voiceRecognizer: VoiceRecognizer, weatherInformUC: WeatherInformUseCase){
        self.colorDisplay = colorDisplay
        self.voiceDetector = voiceDetector
        self.voiceRecognizer = voiceRecognizer
        self.weatherInformUC = weatherInformUC
    }
    
    private var voiceRecognizer: VoiceRecognizer
    private var voiceDetector: VoiceDetector
    private var colorDisplay: ColorDisplay
    private var weatherInformUC: WeatherInformUseCase
    
    public func start() -> VoiceOrder
    {
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
