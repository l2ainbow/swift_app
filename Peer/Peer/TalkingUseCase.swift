//
//  TalkingUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/14.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

class TalkingUseCase {
    
    var speaker : Speaker
    
    init(speaker: Speaker) {
        self.speaker = speaker
    }
    
    func start(voiceString: String){
        
        let isRepeat = false
        repeat {
            if (KeywordSearcher.search(string: voiceString, keyword: "ごきげんよう")){
                speaker.speak(voice: "こんにちは")
                Thread.sleep(forTimeInterval: 1.0)
            }
        } while(isRepeat)
        
        
    }
    
}
