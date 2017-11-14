//
//  UseCaseController.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class UseCaseController {
    private var voiceOrderUC: VoiceOrderUseCase!
    private var weatherInformUC: WeatherInformUseCase!
    private var followMasterUC: FollowMasterUseCase!
    private var jukeBoxUC: JukeBoxUseCase!
    private var talkingUC: TalkingUseCase!
    
    private var currentUseCase = "None"
    
    init(voiceOrderUC: VoiceOrderUseCase, weatherInformUC: WeatherInformUseCase, followMasterUC: FollowMasterUseCase, jukeBoxUC: JukeBoxUseCase, talkingUC: TalkingUseCase){
        self.voiceOrderUC = voiceOrderUC
        self.weatherInformUC = weatherInformUC
        self.followMasterUC = followMasterUC
        self.jukeBoxUC = jukeBoxUC
        self.talkingUC = talkingUC
    }
    
    /// 音声指令を待ち受ける
    func listenVoiceOrder(){
        currentUseCase = "VoiceOrder"
        let order = voiceOrderUC.start()
        currentUseCase = order.order
        if (currentUseCase == "WeatherInform"){
            weatherInformUC.start(voiceString: order.voiceString)
        }
        else if(currentUseCase == "FollowMaster"){
            followMasterUC.start()
        }
        else if(currentUseCase == "JukeBox"){
            jukeBoxUC.start()
        }
        else if(currentUseCase == "Talking"){
            talkingUC.start(voiceString: order.voiceString)
        }
    }
    
    /// 画面がタップされた時の処理
    func displayDidTapped(){
        if (currentUseCase == "JukeBox"){
            jukeBoxUC.pauseMusic()
        }
        if (currentUseCase == "FollowMaster"){
            followMasterUC.terminate()
        }
    }
    
    /// 画面が長押しされた時の処理
    func displayDidLongPressed(){
        if (currentUseCase == "JukeBox"){
            jukeBoxUC.terminate()
        }
    }
}
