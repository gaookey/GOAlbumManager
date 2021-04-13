//
//  SPAlbumOptions.swift
//  SPAlbumManager
//
//  Created by 高文立 on 2021/4/13.
//

import UIKit
import Photos

public class SPAlbumOptions {
    
    static public let shared = SPAlbumOptions()
    
    private init() { } 
    
    public lazy var manager = PHImageManager()
    
    public lazy var imageOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        return option
    }()
    
    public lazy var videoOptions: PHVideoRequestOptions = {
        let option = PHVideoRequestOptions()
        option.isNetworkAccessAllowed = true
        return option
    }()
    
    public lazy var livePhotoOptions: PHLivePhotoRequestOptions = {
        let option = PHLivePhotoRequestOptions()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        return option
    }()
}
