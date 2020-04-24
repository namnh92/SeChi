//
//  HMPermission.swift
//  TimXe
//
//  Created by Nguyễn Nam on 5/14/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import Photos

class HMPermission {
    static var cameraAuthStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    static func requestCameraPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch HMPermission.cameraAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    static var photoAuthStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    static func requestPhotoPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch HMPermission.photoAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        }
    }
    
    static var recordStatus: AVAudioSession.RecordPermission {
        return AVAudioSession.sharedInstance().recordPermission
    }
    
    static func requestRecordPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch recordStatus {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        default:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    static var locationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
}
