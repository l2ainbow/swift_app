//
//  WeatherInformUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

public class WeatherInformUseCase
{
    private var speaker: Speaker
    private var colorDisplay: ColorDisplay
    private var currentLocator: CurrentLocator
    private var weatherProvider: WeatherProvider
    private var messageDisplay: MessageDisplay
    private var weather: Weather?
    private var location: Location?
    
    init(speaker:Speaker , colorDisplay:ColorDisplay , currentLocator:CurrentLocator , weatherProvider:WeatherProvider, messageDisplay:MessageDisplay )
    {
        self.speaker = speaker
        self.colorDisplay = colorDisplay
        self.currentLocator = currentLocator
        self.weatherProvider = weatherProvider
        self.messageDisplay = messageDisplay
    }
    
    /// ユースケースを開始する
    /// - Parameter voiceString: 音声文字列
    public func start(voiceString : String)
    {
        let day = self.getDay(string: voiceString)
        let location = currentLocator.locate()
        let weather = weatherProvider.askWeather(daysLater: day, location: location)
        let message = self.getMessage(day: day, weather: weather)
        messageDisplay.display(message: message)
        let voice = self.getVoice(day: day, weather: weather)
        let color = self.getColor(weather: weather.main)
        speaker.speak(voice: voice)
        colorDisplay.display(color: color)
        if (weather.conjunction != WeatherConjunction.None){
            Thread.sleep(forTimeInterval: 3.0)
            let subVoice = self.getSubVoice(conjunction: weather.conjunction, weather: weather.sub)
            speaker.speak(voice: subVoice)
            let subColor = self.getColor(weather: weather.sub)
            colorDisplay.display(color: subColor)
        }
        speaker.speak(voice: "どす")
        Thread.sleep(forTimeInterval: 3.0)
    }
    
    /// 天気を知りたい日を取得する
    /// - Parameter string: 音声文字列
    /// - Returns: 天気を知りたい日（何日後か）
    private func getDay(string: String) -> Int{
        var day = 0
        if (KeywordSearcher.search(string: string, keywords: ["今日", "本日"])){
            day = 0
        }
        else if (KeywordSearcher.search(string: string, keywords: ["一日後", "明日"])){
            day = 1
        }
        else if (KeywordSearcher.search(string: string, keywords: ["二日後", "明後日"])){
            day = 2
        }
        else if (KeywordSearcher.search(string: string, keywords: ["三日後", "明々後日"])){
            day = 3
        }
        else if (KeywordSearcher.search(string: string, keywords: ["四日後", "弥な明後日", "弥明後日"])){
            day = 4
        }
        else if (KeywordSearcher.search(string: string, keywords: ["五日後"])){
            day = 5
        }
        return day
    }
    
    /// 出力する音声を取得する
    /// - Parameter weather: 天気
    /// - Returns: 音声文字列
    private func getVoice(day: Int, weather: DailyWeather) -> String{
        var voice = ""
        switch day {
        case 0:
            voice += "今日の"
        case 1:
            voice += "明日の"
        case 2:
            voice += "明後日の"
        case 3:
            voice += "明々後日の"
        case 4:
            voice += "四日後の"
        case 5:
            voice += "五日後の"
        default: break
        }
        
        voice += "天気は、"
        voice += weather.main.inJapanese()
        
        return voice
    }
    
    /// サブ天気の音声を取得する
    /// - Parameters:
    ///   - conjunction: 天気予報の接続詞
    ///   - weather: サブ天気
    /// - Returns: 音声文字列
    private func getSubVoice(conjunction: WeatherConjunction, weather: Weather) -> String{
        return conjunction.rawValue + "、" + weather.inJapanese()
    }
    
    /// 表示する色を取得する
    /// - Parameter weather: 天気
    /// - Returns: 表示色
    private func getColor(weather:Weather) -> Color{
        var color: Color = Color.Black
        switch weather {
        case Weather.Clear:
            color = Color.Orange
        case Weather.Cloudy:
            color = Color.Gray
        case Weather.Rain:
            color = Color.Blue
        case Weather.Snow:
            color = Color.White
        case Weather.Thunderstorm:
            color = Color.Yellow
        case Weather.Drizzle:
            color = Color.LightGray
        case Weather.Tornado:
            color = Color.LightBlue
        case Weather.Others:
            color = Color.Red
        default:
            color = Color.Black
        }
        return color
    }
    
    /// 表示するメッセージを取得する
    /// - Parameter weather: 天気
    /// - Returns: 表示メッセージ
    private func getMessage(day: Int, weather: DailyWeather) -> String{
        var message = ""
        switch day {
        case 0:
            message += "今日"
        case 1:
            message += "明日"
        case 2:
            message += "明後日"
        case 3:
            message += "明々後日"
        case 4:
            message += "四日後"
        case 5:
            message += "五日後"
        default: break
        }
        message += "は"
        message += weather.main.inJapanese()
        if (weather.conjunction != WeatherConjunction.None){
            message += weather.conjunction.rawValue + weather.sub.inJapanese()
        }
        return message
    }
}
