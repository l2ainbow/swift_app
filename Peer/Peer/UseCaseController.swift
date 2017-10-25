public class UseCaseController {
  private voiceOrderUC: VoiceOrderUseCase!
  private weatherInformUC: WeatherInformUseCase!
  
  init(voiceOrderUC: VoiceOrderUseCase, weatherInformUC: WeatherInformUseCase){
    self.voiceOrderUC = voiceOrderUC
    self.weatherInformUC = weatherInformUC
  }
  
  func startVoiceRecognize(){
    
  }
}