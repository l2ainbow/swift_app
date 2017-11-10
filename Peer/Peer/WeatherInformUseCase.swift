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
    /// 天気予報を伝える際のスリープ時間 [s]
    private let SLEEPING_TIME = 3
    
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
        let voice = self.getVoice(day: day, weather: weather!)
        let color = self.getColor(weather: weather!)
        let message = self.getMessage(weather: weather!)
        speaker.speak(voice: voice)
        colorDisplay.display(color: color)
        messageDisplay.display(message: message)
        Thread.sleep(forTimeInterval: TimeInterval(SLEEPING_TIME))
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
    /// - Returns: 出力音声文字列
    private func getVoice(day: Int, weather: Weather) -> String{
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
      default:
      }
      
      voice += "天気は、"
      
      switch weather {
      case Weather.Clear:
        voice += "晴れどす"
      case Weather.Cloudy:
        voice += "曇りどす"
      case Weather.Rain:
        voice += "雨どす"
      case Weather.Snow:
        voice += "雪どす"
      case Weather.Thunderstorm:
        voice += "雷どす"
      case Weather.Drizzle:
        voice += "霧どす"
      case Weather.Tornado:
        voice += "竜巻どす"
      case Weather.Others:
        voice += "いろいろどす"
      default:
        voice += "不明どす"
      }
      return voice
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
    private func getMessage(weather: Weather) -> String{
        var message = ""
        switch weather {
        case Weather.Clear:
            message += "晴れ"
        case Weather.Cloudy:
            message += "曇り"
        case Weather.Rain:
            message += "雨"
        case Weather.Snow:
            message += "雪"
        case Weather.Thunderstorm:
            message += "雷"
        case Weather.Drizzle:
            message += "霧"
        case Weather.Tornado:
            message += "竜巻"
        case Weather.Others:
            message += "いろいろ"
        default:
            message += "不明"
        }
        return message
    }

}
