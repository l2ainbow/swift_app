// ˅
import UIKit
// ˄

public class WeatherInformUseCase
{
    // ˅
    init(speaker:Speaker , colorDisplay:ColorDisplay , currentLocator:CurrentLocator , weatherProvider:WeatherProvider )
    {
        self.speaker = speaker
        self.colorDisplay = colorDisplay
        self.currentLocator = currentLocator
        self.weatherProvider = weatherProvider
    }
    // ˄

    private var speaker: Speaker

    private var colorDisplay: ColorDisplay

    private var currentLocator: CurrentLocator

    private var weatherProvider: WeatherProvider

    private var weather: Weather?

    private var location: Location?

    public func start(daysAgo: Int)
    {
        // ˅
        var location = currentLocator.locate()
        var weather = weatherProvider.askWeather(daysAgo: daysAgo, location: location)
        var message = self.getMessage(weather: weather)
        var color = self.getColor(weather: weather)
        speaker.speak(message)
        colorDisplay.display(color)
        // ˄
    }
    
    public func start()
    {
      start(daysAgo: 0)
    }

    // ˅
    private func getMessage(weather: Weather) -> String{
      var message = ""
      switch weather.type {
      case Clear:
        message = "晴れどす"
      case Cloudy:
        message = "曇りどす"
      case Rain:
        message = "雨どす"
      case Snow:
        message = "雪どす"
      case Thunderstorm:
        message = "雷どす"
      case Drizzle:
        message = "霧どす"
      case Tornado:
        message = "竜巻どす"
      case Other:
        message = "いろいろどす"
      default:
        message = "不明どす"
      }
      return message
    }
    
    private func getColor(weather:Weather) -> Color{
      var colorName: ColorName = nil
      switch weather.type {
      case Clear:
        colorName = Orange
      case Cloudy:
        colorName = Gray
      case Rain:
        colorName = Blue
      case Snow:
        colorName = White
      case Thunderstorm:
        colorName = Yellow
      case Drizzle:
        colorName = LightGray
      case Tornado:
        colorName = LightBlue
      case Other:
        colorName = Red
      default:
        colorName = Black
      }
      return Color(colorName)
    }
    // ˄
}

// ˅

// ˄
