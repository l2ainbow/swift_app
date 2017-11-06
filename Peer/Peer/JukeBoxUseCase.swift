//
//  JukeBoxUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/06.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

public class JukeBoxUseCase
{
    private var speaker: Speaker
    private var voiceRecognizer: VoiceRecognizer
    private var musicSearcher: MusicSearcher
    private var musicPlayer: MusicPlayer
    private var colorDisplay: ColorDisplay
    private var messageDisplay: MessageDisplay
    private var runner: Runner
    
    private var musics = [Music]()
    
    init (speaker: Speaker, voiceRecognizer: VoiceRecognizer, musicSearcher: MusicSearcher, musicPlayer: MusicPlayer, colorDisplay: ColorDisplay,  messageDisplay: MessageDisplay, runner: Runner){
        self.speaker = speaker
        self.voiceRecognizer = voiceRecognizer
        self.musicSearcher = musicSearcher
        self.musicPlayer = musicPlayer
        self.colorDisplay = colorDisplay
        self.messageDisplay = messageDisplay
        self.runner = runner
    }
    
    /// ユースケースを開始する
    public func start()
    {
        speaker.speak("どんな曲がええどすか")
        let keyword = voiceRecognizer.recognize()
        if (KeywordSearcher.search(keyword, ["特に無し","聞きたくない","やめる"])){
            speaker.speak("もう呼ばんといて")
            return
        }
        
        musics = musicSearcher.search(keyword)
        if (musics.count == 0){
            speaker.speak("そんな曲はないどすえ")
            return
        }
        speaker.speak("わかりました")
        
        while ((music = self.shuffle(musics)) == nil){
            musicPlayer.play(music)
            colorDisplay.illuminate(3 , [Color.Red, Color.Orange, Color.Yellow, Color.Green, Color.LightBlue, Color.Blue, Color.Purpul], true)
            messageDisplay.display("\(music.artist):\(music.title)")
            runner.spin(10000)
            musicPlayer.waitForEnd()
            colorDisplay.display(Color.White)
            runner.stop()
        }
    }
    
    public func pauseMusic(){
        musicPlayer.pause()
    }
    
    public func terminate(){
        musics.removeAll()
        musicPlayer.terminate()
    }
    
    private shuffle(inout musics: [Music]){
        if (musics == nil || musics.count == 0){
            return nil
        }
        
        let select = arc4random_uniform(musics.count - 1)
        let music = musics[select]
        musics.removeAtIndex(select)
        return music
    }
}
