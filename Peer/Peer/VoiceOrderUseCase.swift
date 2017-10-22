// ˅

// ˄

public class VoiceOrderUseCase: VoiceOrderUseCaseIF
{
    // ˅
    init (colorDisplay: ColorDisplay, voiceDetector: VoiceDetector, voiceRecognizer: VoiceRecognizer, searcher: KeywordSearcher){
        self.colorDisplay = colorDisplay
        self.voiceDetector = voiceDetector
        self.voiceRecognizer = voiceRecognizer
    }
    // ˄

    private var voiceRecognizer: VoiceRecognizer
    private var voiceDetector: VoiceDetector
    private var colorDisplay: ColorDisplay

    public func start()
    {
        // ˅
        colorDisplay.display(Green)
        while(!voiceDetector.detect()){
        }
        
        colorDisplay.display(Yellow)
        
        voiceOrder = voiceRecognizer.recognize()
        
        if (KeywordSearcher.search(string: voiceOrder, keyword: "天気"){
          
          var day = -1
          if (KeywordSearcher.search(string: voiceOrder, keywords: ["今日"])
            day = 0
          else if (KeywordSearcher.search(string: voiceOrder, keywords: ["一日後", "明日"])
            day = 1
          else if (KeywordSearcher.search(string: voiceOrder, keywords: ["二日後", "明後日"])
            day = 2
          else if (KeywordSearcher.search(string: voiceOrder, keywords: ["三日後", "明々後日"])
            day = 3
          else if (KeywordSearcher.search(string: voiceOrder, keywords: ["四日後", "弥な明後日"])
            day = 4
          else if (KeywordSearcher.search(string: voiceOrder, keywords: ["五日後"])
            day = 5
        
          var usecase = WeatherInformUseCase()
          if (day >= 0)
            usecase.start(daysAgo: 1)
          else
            usecase.start()
        }
        // ˄
    }

    // ˅
    
    // ˄
}

// ˅

// ˄
