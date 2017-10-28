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
    init(speaker:Speaker , colorDisplay:ColorDisplay , currentLocator:CurrentLocator , weatherProvider:WeatherProvider )
    {
        self.speaker = speaker
        self.colorDisplay = colorDisplay
        self.currentLocator = currentLocator
        self.weatherProvider = weatherProvider
    }

    private var speaker: Speaker

    private var colorDisplay: ColorDisplay

    private var currentLocator: CurrentLocator

    private var weatherProvider: WeatherProvider

    private var weather: Weather?

    private var location: Location?

    public func start(voiceString : String)
    {
        var day = -1
        if (KeywordSearcher.search(string: voiceString, keywords: ["今日", "本日"])){
            day = 0
        }
        else if (KeywordSearcher.search(string: voiceString, keywords: ["一日後", "明日"])){
            day = 1
        }
        else if (KeywordSearcher.search(string: voiceString, keywords: ["二日後", "明後日"])){
            day = 2
        }
        else if (KeywordSearcher.search(string: voiceString, keywords: ["三日後", "明々後日"])){
            day = 3
        }
        else if (KeywordSearcher.search(string: voiceString, keywords: ["四日後", "弥な明後日", "弥明後日"])){
            day = 4
        }
        else if (KeywordSearcher.search(string: voiceString, keywords: ["五日後"])){
            day = 5
        }
        
        if (day < 0){
            day = 0
        }
        
        let location = currentLocator.locate()
        let weather = weatherProvider.askWeather(daysAgo: day, location: location!)
        let message = self.getMessage(weather: weather!)
        let color = self.getColor(weather: weather!)
        speaker.speak(message: message)
        colorDisplay.display(color: color)
    }

    private func getMessage(weather: Weather) -> String{
      var message = ""
      switch weather {
      case Weather.Clear:
        message = "晴れどす"
      case Weather.Cloudy:
        message = "曇りどす"
      case Weather.Rain:
        message = "雨どす"
      case Weather.Snow:
        message = "雪どす"
      case Weather.Thunderstorm:
        message = "雷どす"
      case Weather.Drizzle:
        message = "霧どす"
      case Weather.Tornado:
        message = "竜巻どす"
      case Weather.Others:
        message = "いろいろどす"
      default:
        message = "不明どす"
      }
      return message
    }
    
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
