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
    
    init(voiceOrderUC: VoiceOrderUseCase, weatherInformUC: WeatherInformUseCase, followMasterUC: FollowMasterUseCase, jukeBoxUC: JukeBoxUseCase){
        self.voiceOrderUC = voiceOrderUC
        self.weatherInformUC = weatherInformUC
        self.followMasterUC = followMasterUC
        self.jukeBoxUC = jukeBoxUC
    }
    
    /// 音声指令を待ち受ける
    func listenVoiceOrder(){
        let order = voiceOrderUC.start()
        if (order.order == "WeatherInform"){
            weatherInformUC.start(voiceString: order.voiceString)
        }
        else if(order.order == "FollowMaster"){
            followMasterUC.start()
        }
        else if(order.order == "JukeBox"){
            jukeBoxUC.start()
        }
    }
    
    func pauseMusic(){
        jukeBoxUC.pauseMusic()
    }
    
    func terminateMusic(){
        jukeBoxUC.terminate()
    }
}
