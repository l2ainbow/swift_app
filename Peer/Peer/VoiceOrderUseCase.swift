// ˅

// ˄

public class VoiceOrderUseCase: VoiceOrderUseCaseIF
{
    // ˅
    init (colorDisplay: ColorDisplay, voiceDetector: VoiceDetector, voiceRecognizer: VoiceRecognizer, weatherInformUC: WeatherInformUseCase){
        self.colorDisplay = colorDisplay
        self.voiceDetector = voiceDetector
        self.voiceRecognizer = voiceRecognizer
        self.weatherInformUC = weatherInformUC
    }
    // ˄
    
    private var voiceRecognizer: VoiceRecognizer
    private var voiceDetector: VoiceDetector
    private var colorDisplay: ColorDisplay
    private var weatherInformUC: WeatherInformUseCase
    
    public func start()
    {
        // ˅
        colorDisplay.display(color: Color.Green)
        while(!voiceDetector.detect()){
        }
        
        colorDisplay.display(color: Color.Yellow)
        
        let voiceOrder = voiceRecognizer.recognize()
        
        if (KeywordSearcher.search(string: voiceOrder, keyword: "天気")){
            
            var day = -1
            if (KeywordSearcher.search(string: voiceOrder, keywords: ["今日", "本日"])){
                day = 0
            }
            else if (KeywordSearcher.search(string: voiceOrder, keywords: ["一日後", "明日"])){
                day = 1
            }
            else if (KeywordSearcher.search(string: voiceOrder, keywords: ["二日後", "明後日"])){
                day = 2
            }
            else if (KeywordSearcher.search(string: voiceOrder, keywords: ["三日後", "明々後日"])){
                day = 3
            }
            else if (KeywordSearcher.search(string: voiceOrder, keywords: ["四日後", "弥な明後日", "弥明後日"])){
                day = 4
            }
            else if (KeywordSearcher.search(string: voiceOrder, keywords: ["五日後"])){
                day = 5
            }
            
            if (day >= 0){
                weatherInformUC.start(daysAgo: day)
            }
            else{
                weatherInformUC.start()
            }
        }
        // ˄
    }
    
    // ˅
    
    // ˄
}

// ˅

// ˄
