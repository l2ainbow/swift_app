//
//  VoiceRecognizerImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//
import Speech
import AudioToolbox

public class VoiceRecognizerImpl: VoiceRecognizer
{
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var text: String = ""
    private var timer: Timer!
    private var resultText: String = ""
    private var isRun: Bool!
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.repeatRecognize(_:)), userInfo: nil, repeats: true)
        timer.fire()
    }
    // 音声を認識する
    // -> 認識した音声文字列
    public func recognize() -> String {
        // TODO: 【外村】ここを実装する
        var result: String = ""
        result = self.resultCheck()
        print("check1 === " + result)
        Thread.sleep(forTimeInterval: 2)
//        if (result.contains("バディ")) {
//            result = ""
//            result = self.resultCheck()
//            print("check2 === " + result)
//        }
//        
        return result
    }
    
    func resultCheck () -> String{
        var result: String = ""
        self.resultText = ""
        self.isRun = true
        while(true) {
            if (self.resultText != "" || !isRun) {
                result = self.resultText
                break
            }
        }
        return result
    }
    func startRecording() throws {
        
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode : AVAudioInputNode = audioEngine.inputNode else {fatalError("Audio engine has no input node")}
        
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        //recognitionRequest.shouldReportPartialResults = true
        
        /* 音声認識スタート */
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false

            if let result = result {
                /* ここで文字列を処理 */
                //self.stopRecording()
                self.text = result.bestTranscription.formattedString
                //print("====\(self.text)")
                isFinal = result.isFinal

            } else {
                print("====result else")
                self.stopRecording()
                self.isRun = false
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }


        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
    }
    
    func stopRecording() {
        if (self.audioEngine.isRunning) {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
        }
        
    }
    
    
    
    @objc func repeatRecognize(_ timer: Timer) {
        
        if (!self.audioEngine.isRunning) {
            print("start")
            try! self.startRecording()
        }
        if (self.text != "") {
            self.resultText = self.text
            self.text = ""
            stopRecording()
            print("stop")
        }
        
    }
    
}



