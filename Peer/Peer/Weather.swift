//
//  Weather.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

/// 天気
/// - Clear: 晴れ
/// - Cloudy: 曇り
/// - Rain: 雨
/// - Snow: 雪
/// - Thunderstorm: 雷
/// - Drizzle: 霧
/// - Tornado: トルネード
/// - Others: その他
public enum Weather : Int
{
    // TODO: 「雨のち晴れ」等のバリエーションを増やす
    case Clear = 0, Cloudy, Rain, Snow, Thunderstorm, Drizzle, Tornado, None, Others
    
    /// 天気を全て取得する
    /// - Returns: 全ての天気
    static func all()-> AnySequence<Weather>{
        return AnySequence{
            return WeathersGenerator()
        }
    }
    
    func inJapanese() -> String {
        switch self {
        case .Clear:
            return "晴れ"
        case .Cloudy:
            return "曇り"
        case .Rain:
            return "雨"
        case .Snow:
            return "雪"
        case .Thunderstorm:
            return "雷"
        case .Drizzle:
            return "霧"
        case .Tornado:
            return "竜巻"
        case .None:
            return "無し"
        case .Others:
            return "色々"
        }
    }
    
    /// 天気を全て取得するための構造体
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

/// 天気の接続詞
/// - And: のち
/// - Sometimes: 時々
/// - Temporary: 一時
/// - None: なし
public enum WeatherConjunction : String
{
    case And = "のち"
    case Sometimes = "時々"
    case Temporary = "一時"
    case None = ""
}

public struct DailyWeather {
    var main: Weather
    var conjunction: WeatherConjunction
    var sub: Weather
}
