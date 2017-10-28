public class UseCaseController {
    private var voiceOrderUC: VoiceOrderUseCase!
    private var weatherInformUC: WeatherInformUseCase!
    
    init(voiceOrderUC: VoiceOrderUseCase, weatherInformUC: WeatherInformUseCase){
        self.voiceOrderUC = voiceOrderUC
        self.weatherInformUC = weatherInformUC
    }
    
    func listenVoiceOrder(){
        let order = voiceOrderUC.start()
        weatherInformUC.start(voiceString: order.voiceString)
    }
}
