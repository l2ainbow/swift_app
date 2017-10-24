//
//  Initializer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

class Initializer {
    static func initialize(delegate: ViewController) -> VoiceOrderUseCase{
        delegate.colorDisplay = ColorDisplayImpl(view: delegate.view, peripheral: delegate.peripheral, characteristic: delegate.ledCharacteristic)
        delegate.messageDisplay = MessageDisplayImpl(label: delegate.conditionText)
        
        let voiceDetector = MockVoiceDetector()
        let voiceRecognizer = MockVoiceRecognizer()
        let speaker = SpeakerImpl()
        let locator = MockCurrentLocator()
        let provider = MockWeatherProvider()
        
        let weatherInformUC = WeatherInformUseCase(speaker: speaker, colorDisplay: delegate.colorDisplay, currentLocator: locator, weatherProvider: provider)
        let voiceOrderUseCase = VoiceOrderUseCase(colorDisplay: delegate.colorDisplay, voiceDetector: voiceDetector, voiceRecognizer: voiceRecognizer, weatherInformUC: weatherInformUC)
        
        return voiceOrderUseCase
    }
}
