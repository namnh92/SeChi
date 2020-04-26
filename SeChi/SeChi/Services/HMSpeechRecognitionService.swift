//
//  HMSpeechRecognitionService.swift
//  AppStore
//
//  Created by NamNH on 4/23/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit
import AVFoundation

class HMSpeechRecognitionService: NSObject {

    // MARK: - Singleton
    static let instance = HMSpeechRecognitionService()
    
    // MARK: - Variables
    private var audioRecorder: AVAudioRecorder?
    private var metersTimer: Timer?
    private var currentInterval: CGFloat = 0
    private var requestApiAfterStop = true
    
    // MARK: - Closures
    var didReceiveMessages: ((_ messages: [String?]) -> Void)?
    var didStopRecording: (() -> Void)?
    var didGetDecibel: ((_ decibel: CGFloat) -> Void)?
    
    // MARK: - Init & deinit
    override init() {
        super.init()
        setupAudioSession()
    }
    
    // MARK: - Setup
    private func setupAudioSession() {
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("speech_recog.wav")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 1,
             AVSampleRateKey: 16000.0] as [String: Any]
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("-> [Speech Recognition] AudioSession error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Action
    func startRecording() {
        setSessionPlayer(on: true)
        requestApiAfterStop = true
        audioRecorder?.record()
        audioRecorder?.updateMeters()
        startMetersTimer()
    }
    
    func stopRecording(requestAPIAfterStop: Bool) {
        self.requestApiAfterStop = requestAPIAfterStop
        stopMetersTimer()
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        }
    }
    
    private func startMetersTimer() {
        stopMetersTimer()
        metersTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                           target: self,
                                           selector: #selector(metersTimerAction(timer:)),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    private func stopMetersTimer() {
        metersTimer?.invalidate()
        metersTimer = nil
        currentInterval = 0
    }
    
    @objc private func metersTimerAction(timer: Timer) {
        guard let recorder = audioRecorder else { return }
        currentInterval += 0.1
        recorder.updateMeters()
        let decibels = recorder.averagePower(forChannel: 0)
        didGetDecibel?(CGFloat(decibels))
        print("-> [Speech Recognition] Decibels: \(decibels)")
        if currentInterval >= 2 && decibels > -120  && decibels < -30 {
            stopRecording(requestAPIAfterStop: true)
        }
    }
    
    private func setSessionPlayer(on: Bool) {
        if on {
            do {
                try AVAudioSession.sharedInstance().setCategory(.record, mode: .default, options: [])
            } catch _ { }
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch _ { }
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
            } catch _ { }
        } else {
            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch _ { }
        }
    }
    
    
    // MARK: - Builder
    func startSpeechAnalyzingWithAudioFrom(url: URL) {
        print("-> [Speech Recognition] File url path: \(url)")
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = try? Data(contentsOf: url) {
//                HMWebSocketService.instance.recognize(inputSteam: InputStream(data: data))
                HMWebSocketService.instance.recognize(assetURL: url)
                HMWebSocketService.instance.didReceiveJSON = { json in
                    let messages = json["result"]["hypotheses"].arrayValue.map({ $0["transcript_normed"].string })
                    let filterMessages = messages.filter({ $0 != "" && $0 != "<unknown>" })
                    self.didReceiveMessages?(filterMessages)
                }
//                HMSpeechToTextAPI(data: data)
//                    .showIndicator(false)
//                    .autoShowApiErrorAlert(false)
//                    .autoShowRequestErrorAlert(false)
//                    .execute(target: nil, success: { response in
//                    print("-> [Speech Recognition] Received messages: \(response.messages)")
//                    let filterMessages = response.messages.filter({ $0 != "" && $0 != "<unknown>" })
//                    self.didReceiveMessages?(filterMessages)
//                }, failure: { error in
//                    self.didReceiveMessages?([])
//                })
            }
        }
    }
}

extension HMSpeechRecognitionService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if requestApiAfterStop {
            startSpeechAnalyzingWithAudioFrom(url: recorder.url)
        }
        didStopRecording?()
        setSessionPlayer(on: false)
    }
}

