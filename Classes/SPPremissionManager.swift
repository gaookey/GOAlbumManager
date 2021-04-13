//
//  SPPremissionManager.swift
//  SPAlbumManager
//
//  Created by 高文立 on 2021/4/13.
//

import UIKit
import Photos

public class SPPremissionManager {
    
    public enum SPAlbumPremissionState: Int {
        case authorized
        case unauthorized
        case limited
    }
    
    static public let shared = SPPremissionManager()
    
    private init() { }
    
    public func camera(completionHandler: ((Bool) -> ())?) {
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            completionHandler?(true)
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                DispatchQueue.main.async {
                    completionHandler?(granted)
                }
            }
        } else {
            completionHandler?(false)
        }
    }
    
    public func album(completionHandler: ((SPAlbumPremissionState) -> ())?) {
        var status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        }
        
        if status == .authorized {
            DispatchQueue.main.async {
                completionHandler?(.authorized)
            }
        } else if status == .notDetermined {
            var state = SPAlbumPremissionState.unauthorized
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                    if status == .authorized {
                        state = .authorized
                    } else if status == .limited {
                        state = .limited
                    } else {
                        state = .unauthorized
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized {
                        state = .authorized
                    } else {
                        state = .unauthorized
                    }
                }
            }
            
            DispatchQueue.main.async {
                completionHandler?(state)
            }
        } else {
            DispatchQueue.main.async {
                completionHandler?(.unauthorized)
            }
        }
    }
}
