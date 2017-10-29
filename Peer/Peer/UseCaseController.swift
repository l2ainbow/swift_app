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
    
    init(voiceOrderUC: VoiceOrderUseCase, weatherInformUC: WeatherInformUseCase){
        self.voiceOrderUC = voiceOrderUC
        self.weatherInformUC = weatherInformUC
    }
    
    /// 音声指令を待ち受ける
    func listenVoiceOrder(){
        let order = voiceOrderUC.start()
        if (order.order == "WeatherInform"){
            weatherInformUC.start(voiceString: order.voiceString)
        }
    }
}
