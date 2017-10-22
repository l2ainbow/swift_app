//
//  Initializer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

class Initializer {
    static func initialize() -> VoiceOrderUseCase{
        let colorDisplay = MockColorDisplay()
        let voiceDetector = MockVoiceDetector()
        let voiceRecognizer = MockVoiceRecognizer()
        let speaker = MockSpeaker()
        let locator = MockCurrentLocator()
        let provider = MockWeatherProvider()
        let weatherInformUC = WeatherInformUseCase(speaker: speaker, colorDisplay: colorDisplay, currentLocator: locator, weatherProvider: provider)
        let voiceOrderUseCase = VoiceOrderUseCase(colorDisplay: colorDisplay, voiceDetector: voiceDetector, voiceRecognizer: voiceRecognizer, weatherInformUC: weatherInformUC)
        
        return voiceOrderUseCase
    }
}