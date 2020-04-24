//
//  HMAddReminderVC.swift
//  HeyBeri
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMAddReminderVC: HMBaseVC {

    @IBOutlet weak var inputTF: UITextField!
    @IBOutlet weak var soundWaveView: HMSoundWaveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HMSpeechRecognitionService.instance.startRecording()
    }

    override func setupView() {
        super.setupView()
        
        HMSpeechRecognitionService.instance.didReceiveMessages = { [weak self] messages in
            if messages.count > 0 {
                self?.inputTF.text = messages[0]
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self?.dismissToRoot()
                })
            } else {
//                HMSpeechRecognitionService.instance.startRecording()
            }
        }
        
        HMSpeechRecognitionService.instance.didGetDecibel = { [weak self] decibel in
            self?.soundWaveView.add(decibelValue: decibel)
        }
    }

}
