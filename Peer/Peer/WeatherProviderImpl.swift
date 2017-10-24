import Foundation

public class WeatherProviderImpl: WeatherProvider
{
    let MAX_DAYS = 5
    let OPEN_WEATHER_MAP_URL = "http://atode"
    public func askWeather(daysAgo: Int, location: Location) -> Weather?
    {
        if (daysAgo > MAX_DAYS){
            return nil
        }
        let urlStr = OPEN_WEATHER_MAP_URL + "lat=" + String(location.latitude) + "&lon=" + String(location.longitude)
        let url = URL(string: urlStr)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {data, response, error in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json!)
            }
        })
        
        task.resume()
        
        return nil
    }
}
