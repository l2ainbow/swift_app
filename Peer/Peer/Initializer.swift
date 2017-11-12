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
        delegate.colorDisplay = ColorDisplayImpl(view: delegate.view)
        delegate.messageDisplay = MessageDisplayImpl(label: delegate.conditionText)
        delegate.speaker = SpeakerImpl()
        delegate.rightMotor = Motor(type: .Right)
        delegate.leftMotor = Motor(type: .Left)
        
        let voiceDetector = VoiceDetectorImpl()
        let voiceRecognizer = VoiceRecognizerImpl()
        let locator = CurrentLocatorImpl()
        let provider = WeatherProviderImpl()
        let masterRecognizer = MasterRecognizerImpl()
        let runner = RunnerImpl(rightMotor: delegate.rightMotor, leftMotor: delegate.leftMotor)
        let follower = Follower(runner: runner)
        let musicSearcher = MusicSearcherImpl()
        let musicPlayer = MusicPlayerImpl()
        
        let weatherInformUC = WeatherInformUseCase(speaker: delegate.speaker, colorDisplay: delegate.colorDisplay, currentLocator: locator, weatherProvider: provider, messageDisplay: delegate.messageDisplay)
        let voiceOrderUC = VoiceOrderUseCase(colorDisplay: delegate.colorDisplay, voiceDetector: voiceDetector, voiceRecognizer: voiceRecognizer, messageDisplay: delegate.messageDisplay)
        let followMasterUC = FollowMasterUseCase(colorDisplay: delegate.colorDisplay, masterRecognizer: masterRecognizer, follower: follower, messageDisplay: delegate.messageDisplay)
        let jukeBoxUC = JukeBoxUseCase(speaker: delegate.speaker, voiceRecognizer: voiceRecognizer, musicSearcher: musicSearcher, musicPlayer: musicPlayer, colorDisplay: delegate.colorDisplay, messageDisplay: delegate.messageDisplay, runner: runner)
        
        delegate.useCaseController = UseCaseController(voiceOrderUC: voiceOrderUC, weatherInformUC: weatherInformUC, followMasterUC: followMasterUC, jukeBoxUC: jukeBoxUC)
    }
}
