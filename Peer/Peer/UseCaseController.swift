//
//  UseCaseController.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

public class UseCaseController {
    private var voiceOrderUC: VoiceOrderUseCase!
    private var weatherInformUC: WeatherInformUseCase!
    private var followMasterUC: FollowMasterUseCase!
    
    init(voiceOrderUC: VoiceOrderUseCase, weatherInformUC: WeatherInformUseCase, followMasterUC: FollowMasterUseCase){
        self.voiceOrderUC = voiceOrderUC
        self.weatherInformUC = weatherInformUC
        self.followMasterUC = followMasterUC
    }
    
    /// 音声指令を待ち受ける
    func listenVoiceOrder(){
        let queue = DispatchQueue(label: "useCaseController.listenVoiceOrder")
        queue.async{
            while(true){
                let order = self.voiceOrderUC.start()
                if (order.order == "WeatherInform"){
                    self.weatherInformUC.start(voiceString: order.voiceString)
                }
                else if(order.order == "FollowMaster"){
                    self.followMasterUC.start()
                }
            }
        }
    }
    
}
