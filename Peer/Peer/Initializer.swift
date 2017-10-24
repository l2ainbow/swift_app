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
        delegate.speaker = SpeakerImpl()
        
        let voiceDetector = MockVoiceDetector()
        let voiceRecognizer = MockVoiceRecognizer()
        let locator = MockCurrentLocator()
        let provider = MockWeatherProvider()
        
        let weatherInformUC = WeatherInformUseCase(speaker: delegate.speaker, colorDisplay: delegate.colorDisplay, currentLocator: locator, weatherProvider: provider)
        let voiceOrderUseCase = VoiceOrderUseCase(colorDisplay: delegate.colorDisplay, voiceDetector: voiceDetector, voiceRecognizer: voiceRecognizer, weatherInformUC: weatherInformUC)
        
        return voiceOrderUseCase
    }
}
