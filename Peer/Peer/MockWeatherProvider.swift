//
//  MockWeatherProvider.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class MockWeatherProvider: WeatherProvider
{
    public func askWeather(daysLater: Int, location: Location) -> Weather?
    {
        print("daysLater: \(daysLater), location: \(location.latitude), longitude: \(location.longitude)")
        return Weather.Clear
    }
}
