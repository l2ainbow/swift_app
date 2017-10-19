// ˅

// ˄

public class VoiceDetectorImpl: VoiceDetector
{
    // ˅
    init(voiceOrderUseCase: VoiceOrderUseCaseIF){
        self.voiceOrderUseCase = voiceOrderUseCase
    }
    // ˄

    private var voiceOrderUseCase: VoiceOrderUseCaseIF

    public func detect() -> Bool
    {
        // ˅
        return false
        // ˄
    }

    // ˅
    
    // ˄
}

// ˅

// ˄
