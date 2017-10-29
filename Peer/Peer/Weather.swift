//
//  Weather.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

// 天気
public enum Weather : Int
{
    case Clear = 0, Cloudy, Rain, Snow, Thunderstorm, Drizzle, Tornado, Others
    
    // 天気を全て取得する
    // -> 全ての天気
    static func all()-> AnySequence<Weather>{
        return AnySequence{
            return WeathersGenerator()
        }
    }
    
    private struct WeathersGenerator: IteratorProtocol{
        var current = 0
        
        mutating func next() -> Weather?{
            guard let item = Weather(rawValue: current) else {
                return nil
            }
            current += 1
            return item
        }
    }
}
