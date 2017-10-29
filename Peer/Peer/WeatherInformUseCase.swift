//
//  WeatherInformUseCase.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import UIKit

public class WeatherInformUseCase
{
    private var speaker: Speaker
    private var colorDisplay: ColorDisplay
    private var currentLocator: CurrentLocator
    private var weatherProvider: WeatherProvider
    private var weather: Weather?
    private var location: Location?

    init(speaker:Speaker , colorDisplay:ColorDisplay , currentLocator:CurrentLocator , weatherProvider:WeatherProvider )
    {
        self.speaker = speaker
        self.colorDisplay = colorDisplay
        self.currentLocator = currentLocator
        self.weatherProvider = weatherProvider
    }
    
    /// ユースケースを開始する
    /// - Parameter voiceString: 音声文字列
    public func start(voiceString : String)
    {
        let day = self.getDay(string: voiceString)
        let location = currentLocator.locate()
        let weather = weatherProvider.askWeather(daysLater: day, location: location!)
        let voice = self.getVoice(weather: weather!)
        let color = self.getColor(weather: weather!)
        speaker.speak(voice: voice)
        colorDisplay.display(color: color)
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
    private func getVoice(weather: Weather) -> String{
      var voice = ""
      switch weather {
      case Weather.Clear:
        voice = "晴れどす"
      case Weather.Cloudy:
        voice = "曇りどす"
      case Weather.Rain:
        voice = "雨どす"
      case Weather.Snow:
        voice = "雪どす"
      case Weather.Thunderstorm:
        voice = "雷どす"
      case Weather.Drizzle:
        voice = "霧どす"
      case Weather.Tornado:
        voice = "竜巻どす"
      case Weather.Others:
        voice = "いろいろどす"
      default:
        voice = "不明どす"
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
}
