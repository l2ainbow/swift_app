//
//  WeatherProviderImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

public class WeatherProviderImpl: WeatherProvider
{
    let MAX_DAYS = 5
    let OPEN_WEATHER_MAP_URL = "https://api.openweathermap.org/data/2.5/forecast?"
    let API_KEY = "01f33ec55ee44e079c0b1e2b2ec043e4"
    
    public func askWeather(daysAgo: Int, location: Location) -> Weather?
    {
        if (daysAgo > MAX_DAYS){
            return nil
        }
        let urlStr = OPEN_WEATHER_MAP_URL + "lat=" + String(location.latitude) + "&lon=" + String(location.longitude) + "&APPID=" + API_KEY
        let url = URL(string: urlStr)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {data, response, error in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json!)
            }
        })
        
        task.resume()
        
        return Weather.Clear
    }
}
