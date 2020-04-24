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
    
    var didAddReminder: ((String?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HMSpeechRecognitionService.instance.startRecording()
    }

    override func setupView() {
        super.setupView()
        inputTF.delegate = self
        HMSpeechRecognitionService.instance.didReceiveMessages = { [weak self] messages in
            if messages.count > 0 {
                self?.inputTF.text = messages[0]
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self?.didAddReminder?(self?.inputTF.text)
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

extension HMAddReminderVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didAddReminder?(textField.text)
        dismissToRoot()
        return true
    }
}
