//
//  MockWeatherProvider.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class MockWeatherProvider: WeatherProvider
{
    public /// 天気を問い合わせる
    /// - Parameters:
    ///   - daysLater: 知りたい日（何日後か）
    ///   - location: 知りたい場所
    /// - Returns: その日その場所の天気
    func askWeather(daysLater: Int, location: Location) -> DailyWeather {
        print("daysLater: \(daysLater), location: \(location.latitude), longitude: \(location.longitude)")
        return DailyWeather(main: Weather.Clear, conjunction: WeatherConjunction.And, sub: Weather.Cloudy)
    }

    public func askWeather(daysLater: Int, location: Location) -> Weather?
    {
        print("daysLater: \(daysLater), location: \(location.latitude), longitude: \(location.longitude)")
        return Weather.Clear
    }
}
