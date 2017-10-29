//
//  WeatherProvider.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol WeatherProvider
{
    // 天気を問い合わせる
    // daysLater: 知りたい日（何日前か）
    // location: 知りたい場所
    // -> その日その場所の天気
    func askWeather(daysLater: Int, location: Location) -> Weather?
}
