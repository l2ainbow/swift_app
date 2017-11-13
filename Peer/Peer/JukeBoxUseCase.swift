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
        speaker.speak(voice: "どんな曲がええどすか")
        let keyword = voiceRecognizer.recognize()
        if (KeywordSearcher.search(string: keyword, keywords: ["特に無し","聞きたくない","やめる"])){
            speaker.speak(voice: "もう呼ばんといて")
            return
        }
        
        musics = musicSearcher.search(keyword: keyword)
        if (musics.count == 0){
            speaker.speak(voice: "そんな曲はないどすえ")
            return
        }
        speaker.speak(voice: "わかりました")
        Thread.sleep(forTimeInterval: 2)
        
        while let music = self.shuffle(musics: &musics){
            musicPlayer.play(music: music)
            self.colorDisplay.illuminate(interval: 3 , colors: [Color.Red, Color.Orange, Color.Yellow, Color.Green, Color.LightBlue, Color.Blue, Color.Purple], isRepeat: true)
            messageDisplay.display(message: "\(music.artist): \(music.title)")
            self.runner.spin(angle: 10000)
            self.musicPlayer.waitForEnd()
            self.colorDisplay.display(color: Color.White)
            self.runner.stop()
        }
        self.messageDisplay.display(message: "音楽再生終了")
    }
    
    /// 音楽を一時停止する
    public func pauseMusic(){
        musicPlayer.pause()
        // - TODO: 音楽の一時停止時に色の変更を止めるように修正
    }
    
    /// ユースケースを終了する
    public func terminate(){
        musics.removeAll()
        musicPlayer.terminate()
    }
    
    /// 音楽をシャッフル選択する（選択された音楽は配列からは除外する）
    /// - Parameters: 
    ///   - musics: 音楽の配列
    /// - Returns: 選択された音楽
    private func shuffle(musics: inout [Music]) -> Music?{
        if (musics.count == 0){
            return nil
        }
        
        let select = Int(arc4random_uniform(UInt32(musics.count - 1)))
        let music = musics[select]
        musics.remove(at: select)
        return music
    }
}
