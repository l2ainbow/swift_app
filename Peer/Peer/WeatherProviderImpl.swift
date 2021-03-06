//
//  WeatherProviderImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation
import Dispatch

public class WeatherProviderImpl: WeatherProvider
{
    /// 天気取得可能な最大日数（何日後までか）
    let MAX_DAYS = 5
    /// OpenWeatherMapのURL
    let OPEN_WEATHER_MAP_URL = "https://api.openweathermap.org/data/2.5/forecast?"
    /// APIキー
    let API_KEY = "01f33ec55ee44e079c0b1e2b2ec043e4"
    
    /// 天気を問い合わせる
    /// - Parameters:
    ///   - daysLater: 知りたい日（何日後か）
    ///   - location: 知りたい場所
    /// - Returns: 知りたい日知りたい場所の天気
    public func askWeather(daysLater: Int, location: Location) -> Weather?
    {
        if (daysLater > MAX_DAYS){
            return nil
        }
        let urlStr = OPEN_WEATHER_MAP_URL + "lat=" + String(location.latitude) + "&lon=" + String(location.longitude) + "&APPID=" + API_KEY
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        let semaphore = DispatchSemaphore(value: 0)
        var json : Any?
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            if let data = data {
                json = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            semaphore.signal()
        })
        
        task.resume()
        semaphore.wait()
        
        let ids = parse(json: json)
        let weather = getWeather(daysLater: daysLater, weatherIds: ids)
        
        return weather
    }
    
    /// JSONを解析する
    /// - Parameter json: JSON文字列
    /// - Returns: (key = UNIX時刻, value = 天気ID)のDictionary型
    private func parse(json: Any?) -> Dictionary<Int, Int>{
        var weatherIds : Dictionary<Int, Int> = [:]
        if let root = json as?[String: Any]{
            if let list = root["list"] as? [Any]{
                for item in list {
                    if let sItem = item as? [String: Any]{
                        if let dt = sItem["dt"] as? Int {
                            if let wArray = sItem["weather"] as? [Any]{
                                for wItem in wArray{
                                    if let weather = wItem as? [String: Any]{
                                        if let id = weather["id"] as? Int{
                                            weatherIds[dt] = id
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return weatherIds
    }
    
    /// 天気を取得する
    /// - Parameters:
    ///   - daysLater: 知りたい日（何日後か）
    ///   - weatherIds: (key = UNIX時刻, value = 天気ID)のDictionary型
    /// - Returns: 知りたい日の天気
    private func getWeather(daysLater: Int, weatherIds: Dictionary<Int, Int>) -> Weather{
        var weather = Weather.Others
        
        var cntWeather = Dictionary<Weather, Int>()
        
        for w in Weather.all(){
            cntWeather.updateValue(0, forKey: w)
        }
        
        let date = Date(timeIntervalSinceNow: TimeInterval(daysLater * 24 * 60 * 60))
        let calendar = Calendar(identifier: Calendar.Identifier.japanese)
        for id in weatherIds{
            let weatherDate = Date(timeIntervalSince1970: TimeInterval(id.key))
            if calendar.isDate(weatherDate, inSameDayAs: date){
                let w = convertIdToWeather(id: id.value)
                cntWeather[w] = cntWeather[w]! + 1
            }
        }
        
        var max = 0
        for c in cntWeather{
            if c.value > max {
                weather = c.key
                max = c.value
            }
        }
        
        return weather
    }
    
    /// 天気IDを天気に変換する
    /// - Parameter id: 天気ID
    /// - Returns: 天気
    private func convertIdToWeather(id: Int) -> Weather{
        var weather : Weather
        let group = Int(id/100)
        switch group {
        case 2:
            weather = Weather.Thunderstorm
        case 3:
            weather = Weather.Drizzle
        case 5:
            weather = Weather.Rain
        case 6:
            weather = Weather.Snow
        case 7:
            weather = (id == 781) ? Weather.Tornado : Weather.Others
        case 8:
            weather = (id == 800) ? Weather.Clear : Weather.Cloudy
        case 9:
            weather = (id == 900) ? Weather.Tornado : Weather.Others
        default:
            weather = Weather.Others
        }
        return weather
    }
}
