// ˅

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

    private func InformWeather(daysAgo: Int)
    {
        // ˅
        
        // ˄
    }

    // ˅
    
    // ˄
}

// ˅

// ˄
