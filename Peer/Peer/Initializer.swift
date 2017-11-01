//
//  Initializer.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

// 初期化のためのクラス
class Initializer {
    
    // 初期化を行う
    // delegate: 初期化する呼び出し元のViewController
    static func initialize(delegate: ViewController){
        delegate.colorDisplay = ColorDisplayImpl(view: delegate.view, peripheral: delegate.peripheral, characteristic: delegate.ledCharacteristic)
        delegate.messageDisplay = MessageDisplayImpl(label: delegate.conditionText)
        delegate.speaker = SpeakerImpl()
        
        // TODO: 【外村】VoiceDetectorImplをテストする際に、以下のMockVoiceDetectorをVoiceDetectorImplに変える
        let voiceDetector = VoiceDetectorImpl()
        // TODO: 【外村】VoiceRecognizerImplをテストする際に、以下のMockVoiceRecognizerをVoiceRecognizerImplに変える
        let voiceRecognizer = MockVoiceRecognizer()
        let locator = MockCurrentLocator()
        let provider = MockWeatherProvider()
        
        let weatherInformUC = WeatherInformUseCase(speaker: delegate.speaker, colorDisplay: delegate.colorDisplay, currentLocator: locator, weatherProvider: provider)
        let voiceOrderUseCase = VoiceOrderUseCase(colorDisplay: delegate.colorDisplay, voiceDetector: voiceDetector, voiceRecognizer: voiceRecognizer)
        
        delegate.useCaseController = UseCaseController(voiceOrderUC: voiceOrderUseCase, weatherInformUC: weatherInformUC)
    }
}
